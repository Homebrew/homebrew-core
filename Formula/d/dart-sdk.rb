class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk.git",
      tag:      "3.14.0",
      revision: "fa8c1270c374c1346931583a17c3b7f278d3822d"
  license "BSD-3-Clause"
  compatibility_version 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95088584b90c2338619fad110494b7e44d1f9fe61cd3fdccb01f4c9677e82dfd"
    sha256 cellar: :any, arm64_tahoe:       "6ad0e27d397749539db7470ffd077d5f72733e101073942c9c027c769d4e0060"
    sha256 cellar: :any, arm64_sequoia:     "d325b40b927d9921f84a84591d42121f21b15ad1bfcb97c71e1174cd11654a27"
    sha256 cellar: :any, arm64_linux:       "30de9dac4b496d17ec3fb464c6f7f98d7195d29ff16605168e9dfe77f2b9de83"
    sha256 cellar: :any, x86_64_linux:      "410563acd62ab44dcc7bde97d33d4f88869e1e0381739d733bdb21dd9dc4d98e"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "43956b3e74de59b07bf8931ba9a472d622fe86a7"
    version "43956b3e74de59b07bf8931ba9a472d622fe86a7"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  allow_network_access! :test

  def fetch
    (buildpath/"sdk-src").install buildpath.children
    (buildpath/"depot-tools").install resource("depot-tools")
    mv "sdk-src", "sdk"

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", buildpath/"depot-tools"

    system "gclient", "config", "--name", "sdk", "file://#{buildpath}/sdk"
    system "gclient", "sync", "--no-history"
  end

  def install
    cd "sdk" do
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      out = OS.mac? ? "xcodebuild" : "out"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "create_sdk"
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    cd "dart-test" do
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end
