class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"
  compatibility_version 1

  stable do
    url "https://github.com/KhronosGroup/MoltenVK/archive/refs/tags/v1.4.1.tar.gz"
    sha256 "9985f141902a17de818e264d17c1ce334b748e499ee02fcb4703e4dc0038f89c"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Cross.git",
          revision: "adec7acbf41a988713cdb85f93f26c8ca5ea863e"
      version "adec7acbf41a988713cdb85f93f26c8ca5ea863e"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Cross_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "SPIRV-Headers" do
      # ExternalRevisions/SPIRV-Headers_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "b824a462d4256d720bebb40e78b9eb8f78bbb305"
      version "b824a462d4256d720bebb40e78b9eb8f78bbb305"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Headers_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "SPIRV-Tools" do
      # ExternalRevisions/SPIRV-Tools_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "262bdab48146c937467f826699a40da0fdfc0f1a"
      version "262bdab48146c937467f826699a40da0fdfc0f1a"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/SPIRV-Tools_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "6aefb8eb95c8e170d0805fd0f2d02832ec1e099a"
      version "6aefb8eb95c8e170d0805fd0f2d02832ec1e099a"

      livecheck do
        url "https://raw.githubusercontent.com/KhronosGroup/MoltenVK/refs/tags/v#{LATEST_VERSION}/ExternalRevisions/Vulkan-Headers_repo_revision"
        regex(/^([0-9a-f]+)$/i)
      end
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "013058f74e2356347f8d9317233bc769816c9dfb"
      version "013058f74e2356347f8d9317233bc769816c9dfb"

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
