class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.690.tar.gz"
  sha256 "3c3cabfca0b12c3e9c4de2440638e5bf7e4489f03553e445bfc2e184598599e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "67fc92e37fc26c81330736f1c01d49b3383f18d1022e417f27f05cf3a2d18575"
    sha256               arm64_golden_gate: "47433ce0e7c6d1e2129ed251e319961ed4ac83ae6fad10bf5545855c2ffcc6a4"
    sha256               arm64_tahoe:       "47433ce0e7c6d1e2129ed251e319961ed4ac83ae6fad10bf5545855c2ffcc6a4"
    sha256               arm64_sequoia:     "2cf1c68501ff608f7511d80da66fd76dcc7b452cab35299940e1bf6e5984ecb0"
    sha256 cellar: :any, arm64_linux:       "6d31f49c01a4d31882b3f574d8f464cdfb7fd71f860ac056cc30d1683fce2696"
    sha256 cellar: :any, x86_64_linux:      "3f0711402e5dc851640c022d149db65e3f2bd8130770d3dd8365b65dd5a290b5"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@25"
  depends_on "php"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "sbt", "--server", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    astgen_suffix << "-mac" if OS.mac?
    libexec.glob("frontends/*/bin/astgen/*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    # Special case for `SwiftAstGen`
    deuniversalize_machos libexec/"frontends/swiftsrc2cpg/bin/astgen/SwiftAstGen-mac" if OS.mac?

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("25")
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_path_exists testpath/"cpg.bin"
  end
end
