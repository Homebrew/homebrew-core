class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.5.1.tar.gz"
  sha256 "1e0d7f4ff07d5099a6acbc3d9dfd0c1f9166324da0201572eee6f77de862d7e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c07e41301a72ff5c7283805eb4a3d7aef57fbae3853bc80132381149ab86fc57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "845793c4b8c4117dfef7d3897bd51cf6f22187bf6bda8360c281f0f3c87ceaea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf26c106d6b905edcb05b757696bd264fc8405cd7f315ad20c5183b8ea5530a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b884d3d6a53f8562c17a5ecb89f93a950e13d3b7ac96549475dc6cd68c6f9a81"
    sha256 cellar: :any_skip_relocation, ventura:        "237a1c26fb1f6bdc83db73ec2c9f80e768c9e852f63ad7f9ab9a7e088a112742"
    sha256 cellar: :any_skip_relocation, monterey:       "43c408a80ccbb0f21a972afe748d59fe572017fa193e51ea8884ac8f001cecd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d69159b7e98dfddd4c7073538f8c9f9cc47920aef6aea8b485ba76e83839cada"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "37a737c1bc8e16cf70212d73466ccca872068dba"
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
