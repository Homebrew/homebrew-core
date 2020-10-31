class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK/archive/v1.1.0.tar.gz"
  sha256 "0538fa1c23ddae495c7f82ccd0db90790a90b7017a258ca7575fbae8021f3058"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "3eda5e70c4f70cdea90c46180574d6b61c8849ca2eeec033ab9c33bb3cae5280" => :catalina
    sha256 "a6875344cb7327b6dd804a82ebd348fda81bb93d2160d0b756a2f133a38e7299" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: ["11.0", :build]
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on macos: :sierra

  # MoltenVK depends on very specific revisions of its dependencies.
  # For each resource the path to the file describing the expected
  # revision is listed.
  resource "cereal" do
    # ExternalRevisions/cereal_repo_revision
    url "https://github.com/USCiLab/cereal.git",
        revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
  end

  resource "Vulkan-Headers" do
    # ExternalRevisions/Vulkan-Headers_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Headers.git",
        revision: "7f9879b1b1fab53f719a9ed5e6e29533b10972b2"
  end

  resource "Vulkan-Portability" do
    # ExternalRevisions/Vulkan-Portability_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Portability.git",
        revision: "53be040f04ce55463d0e5b25fd132f45f003e903"
  end

  resource "SPIRV-Cross" do
    # ExternalRevisions/SPIRV-Cross_repo_revision
    url "https://github.com/KhronosGroup/SPIRV-Cross.git",
        revision: "e6f5ce6b8998f551f3400ad743b77be51bbe3019"
  end

  resource "glslang" do
    # ExternalRevisions/glslang_repo_revision
    url "https://github.com/KhronosGroup/glslang.git",
        revision: "bacaef3237c515e40d1a24722be48c0a0b30f75f"
  end

  resource "SPIRV-Tools" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "0a1fb588cd365f7737cb121fdd64553923e0cef6"
  end

  resource "SPIRV-Headers" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "060627f0b0d2fa8581b5acb939f46e3b9e500593"
  end

  resource "Vulkan-Tools" do
    # ExternalRevisions/Vulkan-Tools_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Tools.git",
        revision: "2bfd6a752dc6cb26ceda4ec9d56e7dce98527680"
  end

  def install
    resources.each do |res|
      res.stage(buildpath/"External"/res.name)
    end
    mv "External/SPIRV-Tools", "External/glslang/External/spirv-tools"
    mv "External/SPIRV-Headers", "External/glslang/External/spirv-tools/external/spirv-headers"

    mkdir "External/glslang/External/spirv-tools/build" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    xcodebuild "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "SYMROOT=External/build", "OBJROOT=External/build",
               "build"

    xcodebuild "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "build"

    (libexec/"lib").install Dir["External/build/macOS/lib{SPIRVCross,SPIRVTools,glslang}.a"]
    glslang_dir = Pathname.new("External/glslang")
    Pathname.glob("External/glslang/{glslang,SPIRV}/**/*.{h,hpp}") do |header|
      header.chmod 0644
      (libexec/"include"/header.parent.relative_path_from(glslang_dir)).install header
    end
    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/glslang/External/spirv-tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Portability/include/vulkan" => "vulkan-portability"

    frameworks.install "Package/Release/MoltenVK/macOS/framework/MoltenVK.framework"
    lib.install "Package/Release/MoltenVK/macOS/dynamic/libMoltenVK.dylib"
    lib.install "Package/Release/MoltenVK/macOS/static/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/" \
                       "macOS/framework/MoltenVKGLSLToSPIRVConverter.framework"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/" \
                       "macOS/framework/MoltenVKSPIRVToMSLConverter.framework"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/" \
                "macOS/dynamic/libMoltenVKGLSLToSPIRVConverter.dylib"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/" \
                "macOS/static/libMoltenVKGLSLToSPIRVConverter.a"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/" \
                "macOS/dynamic/libMoltenVKSPIRVToMSLConverter.dylib"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/" \
                "macOS/static/libMoltenVKSPIRVToMSLConverter.a"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "{MoltenVKGLSLToSPIRVConverter,MoltenVKSPIRVToMSLConverter}"]

    (share/"vulkan").install "MoltenVK/icd" => "icd.d"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>
      int main(void) {
        const char *extensionNames[] = { "VK_KHR_surface" };
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          1, extensionNames,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
