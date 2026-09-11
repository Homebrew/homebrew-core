class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://github.com/dart-lang/sdk/archive/refs/tags/3.13.3.tar.gz"
  sha256 "9320d014e0be89d486f383575d2efcf61d6c948f91338b1da7faf79680a1a3b0"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cafb1a7eeeae149a6fa35b3de850cc405a6843ca98af8bc9bb8dad60b02b0b73"
    sha256 cellar: :any, arm64_sequoia: "0893d6e1f0688a9805bb52320accd9cbb5ca2135c7d7a4e60bd6b0ce94270de5"
    sha256 cellar: :any, arm64_sonoma:  "7dce6ffdbdb39155447e23a5877ead983cb8ee461767c76275b5975ef7744d91"
    sha256 cellar: :any, arm64_linux:   "7aa5b9bb6d40089dabda6fabcfc37b1d483526a366ed67865b1324cc007673b2"
    sha256 cellar: :any, x86_64_linux:  "1f5611ff0953d96aed50344fcbcb9b0a9bdd0e5fc59add5234330f04faa5bf1d"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "cb70c994a656601dc6a0d423f49ff57503bd70bc"
    version "cb70c994a656601dc6a0d423f49ff57503bd70bc"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    # Fix https://github.com/dart-lang/sdk/issues/64264
    # by pulling more recent clang
    inreplace "DEPS", "git_revision:deb6854eec93529b2bd30178d400ad2ee7665cd4",
                      "git_revision:07d67299a15ce03b053736e2d31a668ee0576987"

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
