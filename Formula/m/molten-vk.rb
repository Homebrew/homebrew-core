class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"
  compatibility_version 1

  stable do
    url "https://github.com/KhronosGroup/MoltenVK/archive/refs/tags/v1.4.2.tar.gz"
    sha256 "6864db532f1dbbdb621a8d0ec13f24edae318fd9269dd3dd0cdff791334bb1cb"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Cross.git",
          revision: "6c09849fe88c48eaed08413aa022aaa136a3a057"
      version "6c09849fe88c48eaed08413aa022aaa136a3a057"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Cross_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "SPIRV-Headers" do
      # ExternalRevisions/SPIRV-Headers_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "29981f65241605e08b0ede4cfeb999fe3b723c6a"
      version "29981f65241605e08b0ede4cfeb999fe3b723c6a"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Headers_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "SPIRV-Tools" do
      # ExternalRevisions/SPIRV-Tools_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "0d6fd73ca73830ccab5fa1f00ed5ed40124e2c55"
      version "0d6fd73ca73830ccab5fa1f00ed5ed40124e2c55"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Tools_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "e3b1eec08173d6b825cd3ac88c885a63b621504a"
      version "e3b1eec08173d6b825cd3ac88c885a63b621504a"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/Vulkan-Headers_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "8c66b352925cb771f793a4d3220b1321ae0febf1"
      version "8c66b352925cb771f793a4d3220b1321ae0febf1"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/Vulkan-Tools_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "cereal" do
      # ExternalRevisions/cereal_repo_revision
      url "https://github.com/USCiLab/cereal.git",
          revision: "a56bad8bbb770ee266e930c95d37fff2a5be7fea"
      version "a56bad8bbb770ee266e930c95d37fff2a5be7fea"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/cereal_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0b1bda916255edc08d5a884eec4826e2649a890283b03e6f62e4aa9984cc9b8"
    sha256 cellar: :any, arm64_sequoia: "c37a023bd090ca66e5cec2e0b24f7fcd6a57078ca7cc2a1d661301d01975ee27"
    sha256 cellar: :any, arm64_sonoma:  "0260e56d985f283c9f81af474469285855ce88f48ac5dc31c7a9fb7c2c846aa6"
    sha256 cellar: :any, sonoma:        "9bb2d88ee0ed7cd035f982a59a2e9c5878237c9f4df88117172ccdbc5127f6d9"
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
    # Disable Metal argument buffers for macOS Sonoma on arm
    ENV["MVK_CONFIG_USE_METAL_ARGUMENT_BUFFERS"] = "0" if MacOS.version == :sonoma && Hardware::CPU.arm?

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
