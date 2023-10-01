class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.1.2.tar.gz"
  sha256 "69bbabdefb70a4c60a32920c01e7a7b22a2fc1bf38cd4836c96a935b160e282e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d311bf62d29166baa4498d9f7769c68d4d60d1a26e91856d1d4d50a421a1e1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1743ae3bd305f31a26e8b4483447a779921a8bc0c29c30fe4fff850313e64834"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15aef9c52ad253b901066598eb80192b624d485d60ef26984e903cadc3f2dd79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3298c8fa51ae9cbf4ea7f26ce56dbf79277bc578c648368ec25723bfb325bc4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "78cd0d91e6ac1e941bb4af7456592a599b89bc22fe97001b4739d1fcb76574d7"
    sha256 cellar: :any_skip_relocation, ventura:        "532bb775bb785bafdca96c32ed17b76f603e998624c7fea304586d8f59bc16ff"
    sha256 cellar: :any_skip_relocation, monterey:       "d65f2ddc34076ce9bf155a3d05f7ed757ec652043c2ec96fd43287aeb8c1dbf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c03552ab3cb9b8705bd580533417911bdad5b8eceb21bfa571c6d3d3dee55e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9ac00d2a90de911c47111480ab389fb0376d7985b9dff1e1746594cf96f0e87"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "8bde16478fa1338fc8e392184d5a43de4558de68"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--no-goma", "--mode=release", "--arch=#{arch}", "create_sdk"
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
