class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.10.1.tar.gz"
  sha256 "a06c72d983ef67dc683a8786561a3239c9666664178807f848e072ba589394e5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27b50fc0c63f4be0e61dee01776ffce3180361a1729c3ef26ab3346e18a4ed0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f3c7af5bee05f95eb0d83d5a54a3de737f85edbbf2334b0ee6459009dbc597e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40ff9d613f43661d271dfe47d2fdf9820b299d87f02956eba6bca6d805d21092"
    sha256 cellar: :any_skip_relocation, sonoma:        "960ef836bf2f6510a1c9bc49c1193139484271f756fd40a3a355d9b60316d97b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101b27a8fb07008e297a2cd10d3d1bfb18fee4d1a1a7a54a1050bce751566b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "115633af188d603b33061f3580be2d5d357da743fd9c157ff9c80e3be78f8624"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "5ba2fb94f5ceb4383f528e70183d4c8286c1c171"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
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
