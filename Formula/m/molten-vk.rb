class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"

  stable do
    url "https://github.com/KhronosGroup/MoltenVK/archive/refs/tags/v1.2.8.tar.gz"
    sha256 "85beaf8abfcc54d9da0ff0257ae311abd9e7aa96e53da37e1c37d6bc04ac83cd"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Cross.git",
          revision: "de0e72a0db21d1a12eb37cbfd15199b3e66fc9d9"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "577baa05033cf1d9236b3d078ca4b3269ed87a2b"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "da49add44591bee19975e4668e418591effd8240"
    end

    resource "cereal" do
      # ExternalRevisions/cereal_repo_revision
      url "https://github.com/USCiLab/cereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisions/glslang_repo_revision
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "ee2f5d09eaf8f4e8d0d598bd2172fce290d4ca60"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository at revision of resource above
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "04896c462d9f3f504c99a4698605b6524af813c1"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository at revision of resource above
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "8b246ff75c6615ba4532fe4fde20f1be090c3764"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d5c9c58fb6e8ade6c059a4f8584b4cfb9b77e6d93a6c46856c9c61d72a827b92"
    sha256 cellar: :any, arm64_ventura:  "d5c9c58fb6e8ade6c059a4f8584b4cfb9b77e6d93a6c46856c9c61d72a827b92"
    sha256 cellar: :any, arm64_monterey: "3cebad86a5ed6dbbfb8585c3d53a3b231daf0920d1e828b25d70f96f0739fd0f"
    sha256 cellar: :any, sonoma:         "e71d24f1f20db3dae42699531bf49cf656f533f03291616179f21f99a32680e5"
    sha256 cellar: :any, ventura:        "e71d24f1f20db3dae42699531bf49cf656f533f03291616179f21f99a32680e5"
    sha256 cellar: :any, monterey:       "8830b328d1ce651e6f9ef1be8b85f01c955f055eb0b5c386786a865054d9e0ec"
  end

  head do
    url "https://github.com/KhronosGroup/MoltenVK.git", branch: "main"

    resource "cereal" do
      url "https://github.com/USCiLab/cereal.git", branch: "master"
    end

    resource "Vulkan-Headers" do
      url "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"
    end

    resource "SPIRV-Cross" do
      url "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "main"
    end

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "main"
    end

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end

    resource "Vulkan-Tools" do
      url "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.7", :build]
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on macos: :sierra
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  uses_from_macos "python" => :build, since: :catalina

  def install
    resources.each do |res|
      res.stage(buildpath/"External"/res.name)
    end
    mv "External/SPIRV-Tools", "External/glslang/External/spirv-tools"
    mv "External/SPIRV-Headers", "External/glslang/External/spirv-tools/external/spirv-headers"

    # Build glslang
    cd "External/glslang" do
      system "./build_info.py", ".",
              "-i", "build_info.h.tmpl",
              "-o", "build/include/glslang/build_info.h"
    end

    # Build spirv-tools
    mkdir "External/glslang/External/spirv-tools/build" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "SYMROOT=External/build", "OBJROOT=External/build",
               "build"

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}/build",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "GCC_PREPROCESSOR_DEFINITIONS=${inherited} MVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE",
               "build"

    (libexec/"lib").install Dir["External/build/Release/" \
                                "lib{SPIRVCross,SPIRVTools,glslang}.a"]
    glslang_dir = Pathname.new("External/glslang")
    Pathname.glob("External/glslang/{glslang,SPIRV}/**/*.{h,hpp}") do |header|
      header.chmod 0644
      (libexec/"include"/header.parent.relative_path_from(glslang_dir)).install header
    end
    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/glslang/External/spirv-tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Headers/include/vk_video" => "vk_video"

    frameworks.install "Package/Release/MoltenVK/dynamic/MoltenVK.xcframework"
    lib.install "build/Release/libMoltenVK.dylib"
    lib.install "build/Release/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "MoltenVKShaderConverter"]

    inreplace "MoltenVK/icd/MoltenVK_icd.json",
              "./libMoltenVK.dylib",
              (lib/"libMoltenVK.dylib").relative_path_from(share/"vulkan/icd.d")
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
