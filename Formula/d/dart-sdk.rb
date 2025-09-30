class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.9.3.tar.gz"
  sha256 "1b4322395d53d7e97400d677a2e6d66b3929ffa35898e5f6f51f44b0626ad5d0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4b95e2e31f23628127dfe79ead9dbfe0db810f3ce555a8b82827fe2840d075f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181647029d0af64aca57398a19a6b97cabea84a57e3c797ddf47171dd93d5b66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5e4af76140d6a3206b1a099d447ee9c1f5466ccbfb1134af231307afdb33a24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f152539fe24f666361cd531d7a557ce579c14d8bcf016c84cbbba61a878a918"
    sha256 cellar: :any_skip_relocation, sonoma:        "36fdb451eb6a06f4e0c0a24fe5faee87381f39e061424b7c829cdddb60787232"
    sha256 cellar: :any_skip_relocation, ventura:       "19bc6a1533a8922ccca7d738bf33e166a846b890fc2feca3ed3c9ba715462a6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16a357e5a18bdf1983f6af7f826de1ca868db99ee48e8793b129b0f537dc0768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce8c5cbc45070992837430066a29c4298c48ea08e3afe4ad5a2bc673c764ae1a"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "3ca8f4784d58c6a6d9958b71c191390a8854fb55"
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
