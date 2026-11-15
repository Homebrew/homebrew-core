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
    sha256 cellar: :any, arm64_golden_gate: "14f5d02480782a2bc2f1fdc9f9b26016585c1609d47bf617518bc4927880e432"
    sha256 cellar: :any, arm64_tahoe:       "ab11017acdecdd1b5b666026063d85817616a1339aebcbe4009742d03c359148"
    sha256 cellar: :any, arm64_sequoia:     "eb98ac19e734feee65c9cc942620783ccaa1c8601b9d0af286abc7d6e80ec7aa"
    sha256 cellar: :any, arm64_linux:       "b185ee8351f9ad231f341c79fee83d2eae5491d925429103886145b95b49aee7"
    sha256 cellar: :any, x86_64_linux:      "6164ae76235bce870827eff677b90bc571f6fa5a1bf0b06bba808d429cf2086d"
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
      # Avoid hanging when the bootstrap SDK's VM service cannot bind to localhost in the sandbox
      inreplace "utils/ddc/BUILD.gn", '"--no-source-maps",', '"--no-source-maps", "--omit-memory-summary",'
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
