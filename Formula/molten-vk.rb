class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  url "https://github.com/KhronosGroup/MoltenVK/archive/v1.1.9.tar.gz"
  sha256 "ea455a14decb85ec4bc66ffd2b963492afa7b53297b7064a11ca47ca8d2464ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "40ecbe1cb7fa39206e044bb65de6d1d947ce8c3b9c66dc6d1ad4d13d9852e100"
    sha256 cellar: :any, arm64_big_sur:  "21f71933c797a2dd8707b185de6e73cfe3019ed74a745798ad92e5e3bffa19b4"
    sha256 cellar: :any, monterey:       "dbf1a33eb34c9a29dd9655ebe0f4f1ea4f5fa5312297ddef629599ef7514cdd7"
    sha256 cellar: :any, big_sur:        "740ca02b3a6099e098a309615e3226cfb689e6b6618faa405eb16ac062524845"
    sha256 cellar: :any, catalina:       "54a083e8b4cd0e6e9da512cd9f8112c866ac58ef36e016a1dffd96111244ddfb"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on xcode: ["11.7", :build]
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on macos: :sierra
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

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
        revision: "76f00ef6cbb1886eb1162d1fa39bee8b51e22ee8"
  end

  resource "SPIRV-Cross" do
    # ExternalRevisions/SPIRV-Cross_repo_revision
    url "https://github.com/KhronosGroup/SPIRV-Cross.git",
        revision: "0d4ce028bf8b8a94d325dc1e1c20446153ba19c4"
  end

  resource "glslang" do
    # ExternalRevisions/glslang_repo_revision
    url "https://github.com/KhronosGroup/glslang.git",
        revision: "9bb8cfffb0eed010e07132282c41d73064a7a609"
  end

  resource "SPIRV-Tools" do
    # known_good.json in the glslang repository
    url "https://github.com/KhronosGroup/SPIRV-Tools.git",
        revision: "eed5c76a57bb965f2e1b56d1dc40b50910b5ec1d"
  end

  resource "SPIRV-Headers" do
    # known_good.json in the glslang repository
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "4995a2f2723c401eb0ea3e10c81298906bf1422b"
  end

  resource "Vulkan-Tools" do
    # ExternalRevisions/Vulkan-Tools_repo_revision
    url "https://github.com/KhronosGroup/Vulkan-Tools.git",
        revision: "3903162ac4b01ed376bfa55a72ef7217a72c0b74"
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
