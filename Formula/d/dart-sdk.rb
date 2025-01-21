class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.6.1.tar.gz"
  sha256 "00b5817462155b83d564825817856b4b2e88af1e8c259c68b61727bcb3acbf76"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abc0ee04c47896262a2e7f5cf18e47e87004fbc734cfa5344324314c52750102"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6413b30631c83a09b774e34b9604c222fa0dbd8670498af9e1d5deb3d6643921"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0eda0e719d5a9565259beb842dc65a85b583686e8077186df2a725bc9d6295b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcccfef0dbdb027fe293fa73bff84c5b66bb46e6285ff224a95ba5b7055192d2"
    sha256 cellar: :any_skip_relocation, ventura:       "13f5bc308c2004d8b3312cf25092410df0cbb44715287dc9220686e4ae663520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6a86d4607907ba9f5f8038fbb1345014b4c707dd470eb03c971bf2bc186cc1b"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d6c2e1b3395bbe374ed6950890dd67f709039387"
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
      libexec.install Dir["#{out}/Release#{arch.capitalize}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output(bin/"dart run")
    end
  end
end
