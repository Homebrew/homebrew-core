class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"

  stable do
    url "https://github.com/KhronosGroup/MoltenVK/archive/refs/tags/v1.4.0.tar.gz"
    sha256 "fc74aef926ee3cd473fe260a93819c09fdc939bff669271a587e9ebaa43d4306"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Cross.git",
          revision: "0a88b2d5c08708d45692b7096a0a84e7bfae366c"
    end

    resource "SPIRV-Headers" do
      # ExternalRevisions/SPIRV-Headers_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "bab63ff679c41eb75fc67dac76e1dc44426101e1"
    end

    resource "SPIRV-Tools" do
      # ExternalRevisions/SPIRV-Tools_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "783d7033613cedaa7147d0700b517abc5c32312d"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "088a00d81d1fc30ff77aacf31485871aebec7cb2"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "682e42f7ae70a8fadf374199c02de737daa5c70d"
    end

    resource "cereal" do
      # ExternalRevisions/cereal_repo_revision
      url "https://github.com/USCiLab/cereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c582142652134e00fcddb2b15491492020469d0efc497873b017c45b2ba21a3b"
    sha256 cellar: :any, arm64_sequoia: "9b8177214626a66d3f3d437263fdb5b90617ebabc58a72748eda09024c139c38"
    sha256 cellar: :any, arm64_sonoma:  "fb9f58d36dc493741ba4c5dba69704d29f0dcba0732f2308402be1eabac4d706"
    sha256 cellar: :any, arm64_ventura: "bad2cf52dea78a3561653620af14993927bb1b6873e308b5a9ff3fe8c1cd532b"
    sha256 cellar: :any, sonoma:        "9a16c4a69f8cbb94bea95004f0c686a645df1c3c35ec5fbee23ae0edb9298078"
    sha256 cellar: :any, ventura:       "998675bdd180f03a6acb2a8c908826452f912fde846c3442cf9b821ad004067a"
  end

  head do
    url "https://github.com/KhronosGroup/MoltenVK.git", branch: "main"

    resource "SPIRV-Cross" do
      url "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"
    end

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "main"
    end

    resource "Vulkan-Headers" do
      url "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"
    end

    resource "Vulkan-Tools" do
      url "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "main"
    end

    resource "cereal" do
      url "https://github.com/USCiLab/cereal.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on xcode: ["11.7", :build]
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  uses_from_macos "python" => :build

  def install
    resources.each do |res|
      res.stage(buildpath/"External"/res.name)
    end

    # Build spirv-tools
    mv "External/SPIRV-Headers", "External/spirv-tools/external/spirv-headers"

    mkdir "External/spirv-tools" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
    end

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "SYMROOT=External/build", "OBJROOT=External/build",
               "build"

    if DevelopmentTools.clang_build_version >= 1500 && MacOS.version < :sonoma
      # Required to build xcframeworks with Xcode 15
      # https://github.com/KhronosGroup/MoltenVK/issues/2028
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/SPIRVCross.xcframework",
                "-library", "./External/build/Release/libSPIRVCross.a"
      xcodebuild "-create-xcframework", "-output", "./External/build/Release/SPIRVTools.xcframework",
                "-library", "./External/build/Release/libSPIRVTools.a"
    end

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}/build",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "GCC_PREPROCESSOR_DEFINITIONS=${inherited} MVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE",
               "build"

    (libexec/"lib").install Dir["External/build/Release/" \
                                "lib{SPIRVCross,SPIRVTools}.a"]

    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/SPIRV-Tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Headers/include/vk_video" => "vk_video"

    frameworks.install "Package/Release/MoltenVK/static/MoltenVK.xcframework"
    lib.install "Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib"
    lib.install "build/Release/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "MoltenVKShaderConverter"]

    inreplace "MoltenVK/icd/MoltenVK_icd.json",
              "./libMoltenVK.dylib",
              (lib/"libMoltenVK.dylib").relative_path_from(prefix/"etc/vulkan/icd.d")
    (prefix/"etc/vulkan").install "MoltenVK/icd" => "icd.d"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
