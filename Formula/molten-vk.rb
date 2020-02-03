class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK/archive/v1.0.40.tar.gz"
  sha256 "970d49682f30e7bffba5d4b2ea70ae9e86781d6dbfdd3af4d1aa0c8a68f9646a"

  bottle do
    cellar :any
    sha256 "d955795712c4ec3d4c6ff8bb77615c43679297c90a132c0d02e1971a9efad5a1" => :catalina
    sha256 "aa69f7623d80b63e4108b48b743c9e7808369fd8d00b949b73f4b383198194f1" => :mojave
    sha256 "c046de39ba951a976d844c9dc52255f359503eb31cd57f50e90a186a7d6d66a9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on :xcode => ["11.0", :build]
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on :macos => :sierra

  # MoltenVK depends on very specific revisions of its dependencies.
  # For each resource the path to the file describing the expected
  # revision is listed.
  resource "cereal" do
    # ExternalRevisions/cereal_repo_revision
    url "https://github.com/USCiLab/cereal.git",
        :revision => "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
  end

  resource "Vulkan-Headers" do
    # ExternalRevisions/Vulkan-Headers_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Headers.git",
        :revision => "881bbb347a08d1b5aa77f61a52a30b506de9f2bf"
  end

  resource "Vulkan-Portability" do
    # ExternalRevisions/Vulkan-Portability_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Portability.git",
        :revision => "53be040f04ce55463d0e5b25fd132f45f003e903"
  end

  resource "SPIRV-Cross" do
    # ExternalRevisions/SPIRV-Cross_repo_revision
    url "https://github.com/KhronosGroup/SPIRV-Cross.git",
        :revision => "f9818f0804e6e73ec8afcc523b7e7f8bfc362632"
  end

  resource "glslang" do
    # ExternalRevisions/glslang_repo_revision
    url "https://github.com/KhronosGroup/glslang.git",
        :revision => "4fc7a33910fb8e40b970d160e1b38ab3f67fe0f3"
  end

  resource "SPIRV-Tools" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        :revision => "323a81fc5e30e43a04e5e22af4cba98ca2a161e6"
  end

  resource "SPIRV-Headers" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        :revision => "204cd131c42b90d129073719f2766293ce35c081"
  end

  resource "Vulkan-Tools" do
    # ExternalRevisions/Vulkan-Tools_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Tools.git",
        :revision => "4792a6854238ba3f6d10b8c7fcd11c102cae4ca6"
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
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/macOS/framework/MoltenVKGLSLToSPIRVConverter.framework"
    frameworks.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/macOS/framework/MoltenVKSPIRVToMSLConverter.framework"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/macOS/dynamic/libMoltenVKGLSLToSPIRVConverter.dylib"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKGLSLToSPIRVConverter/macOS/static/libMoltenVKGLSLToSPIRVConverter.a"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/macOS/dynamic/libMoltenVKSPIRVToMSLConverter.dylib"
    lib.install "Package/Release/MoltenVKShaderConverter/MoltenVKSPIRVToMSLConverter/macOS/static/libMoltenVKSPIRVToMSLConverter.a"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/{MoltenVKGLSLToSPIRVConverter,MoltenVKSPIRVToMSLConverter}"]

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
