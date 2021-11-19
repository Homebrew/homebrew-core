class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK/archive/v1.1.6.tar.gz"
  sha256 "b60df3ac93b943eb14377019445533b5c451fffd6b1df86187b1b9ac7d6dba6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "dbed1bab80637de60b5a3a5f12b5cbd52e0c42cc62ba29652e243035fc637b4f"
    sha256 cellar: :any, arm64_big_sur:  "0462e7825b8aa7db2e03e90533b06b1c36ecb10b111d02823d34a1d2fdceffaa"
    sha256 cellar: :any, monterey:       "9739ee5a51f1c7d59336aed77207d707acd1529f0d1791de3a8942db5a71502b"
    sha256 cellar: :any, big_sur:        "680dc3ea038ea88b96a81ac53f0bcf96b6f492f504deab1d9299de6ad451ae49"
    sha256 cellar: :any, catalina:       "9d5b04d2112a1d962129effbd808a7a81afb2bbda38cb9e02e8c20029cb84d9d"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: ["11.7", :build]
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
        revision: "8c1c27d5a9b9de8a17f500053bd08c7ca6bba19c"
  end

  resource "SPIRV-Cross" do
    # ExternalRevisions/SPIRV-Cross_repo_revision
    url "https://github.com/KhronosGroup/SPIRV-Cross.git",
        revision: "7c3cb0b12c9965497b08403c82ac1b82846fa7be"
  end

  resource "glslang" do
    # ExternalRevisions/glslang_repo_revision
    url "https://github.com/KhronosGroup/glslang.git",
        revision: "c9706bdda0ac22b9856f1aa8261e5b9e15cd20c5"
  end

  resource "SPIRV-Tools" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "21e3f681e2004590c7865bc8c0195a4ab8e66c88"
  end

  resource "SPIRV-Headers" do
    # External/glslang/known_good.json
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "814e728b30ddd0f4509233099a3ad96fd4318c07"
  end

  resource "Vulkan-Tools" do
    # ExternalRevisions/Vulkan-Tools_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Tools.git",
        revision: "691252756218fcbd1f0f8d7cc14e753123f08940"
  end

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

    # Create SPIRVCross.xcframework
    xcodebuild "-quiet", "-create-xcframework",
               "-output", "External/build/Latest/SPIRVCross.xcframework",
               "-library", "External/build/Intermediates/XCFrameworkStaging/" \
                           "Release/Platform/libSPIRVCross.a"

    # Create SPIRVTools.xcframework
    xcodebuild "-quiet", "-create-xcframework",
               "-output", "External/build/Latest/SPIRVTools.xcframework",
               "-library", "External/build/Intermediates/XCFrameworkStaging/" \
                           "Release/Platform/libSPIRVTools.a"

    # Created glslang.xcframework
    xcodebuild "-quiet", "-create-xcframework",
               "-output", "External/build/Latest/glslang.xcframework",
               "-library", "External/build/Intermediates/XCFrameworkStaging/" \
                           "Release/Platform/libglslang.a"

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}/build",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "build"

    (libexec/"lib").install Dir["External/build/Intermediates/XCFrameworkStaging/Release/" \
                                "Platform/lib{SPIRVCross,SPIRVTools,glslang}.a"]
    glslang_dir = Pathname.new("External/glslang")
    Pathname.glob("External/glslang/{glslang,SPIRV}/**/*.{h,hpp}") do |header|
      header.chmod 0644
      (libexec/"include"/header.parent.relative_path_from(glslang_dir)).install header
    end
    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/glslang/External/spirv-tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Headers/include/vk_video" => "vk_video"

    frameworks.install "Package/Release/MoltenVK/MoltenVK.xcframework"
    lib.install "Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib"
    lib.install "build/Release/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "MoltenVKShaderConverter"]

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
