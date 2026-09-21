class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.13.4.tar.gz"
  sha256 "8a6040a7998e157e4ff6ec29141a78478aac000b372a2b065a9c53ba40cf8fa9"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "80f9c800af33423f55f208bba4d318bf8582ba14ba1a8178365dfea456839a8f"
    sha256 cellar: :any, arm64_tahoe:       "1ca0c36832ca0a134ac73586a708d513cf4479b5c1e5abd9fd8dcd4a8fc1fb9b"
    sha256 cellar: :any, arm64_sequoia:     "75e0be61be5a87cab5e00c270f62662f38e609b7f49d212c35cbde586effed3e"
    sha256 cellar: :any, arm64_linux:       "ce1743ed20c1f63d34ed33c848082a695c547ccb5b89d80d207f21337291627d"
    sha256 cellar: :any, x86_64_linux:      "c7cd3d6c63fdf924054e7ff57a130695d0af77cf5efbeda732524cc82eb8dff6"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "46afe8bfbb57583700c01d1584e7a49638d586ed"
    version "46afe8bfbb57583700c01d1584e7a49638d586ed"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    # Roll clang to include lld support for arm64e.x1 targets in the macOS 27 SDK (llvm/llvm-project#222721)
    # TODO: Remove when upstream rolls clang past that commit, see https://github.com/dart-lang/sdk/issues/64264
    system "gclient", "config", "--name", "sdk",
           "--custom-var", 'clang_version="git_revision:07d67299a15ce03b053736e2d31a668ee0576987"',
           "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      # The newer clang flags an unused variable in binaryen, which is built with -Werror
      inreplace "third_party/binaryen/BUILD.gn", '"-Wno-unused-private-field",',
                                                   "\\0\n        \"-Wno-unused-variable\","

      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end
