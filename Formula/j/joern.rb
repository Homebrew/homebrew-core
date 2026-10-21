class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.660.tar.gz"
  sha256 "c5c79776c60f8ae1b0e0caa78f0e48e7dd8900070d5da98933de56a01b82ff90"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256               arm64_golden_gate: "eef6e3d7c5c74594601d96553273269eeb552c60d81ee8a441e9961ced61cbca"
    sha256               arm64_tahoe:       "eef6e3d7c5c74594601d96553273269eeb552c60d81ee8a441e9961ced61cbca"
    sha256               arm64_sequoia:     "1a1e1960981f796037a2a2bd06d8c3261a6f1452ca0b61ae87f5afd500f7143c"
    sha256 cellar: :any, arm64_linux:       "0b326e6d593fdb828e7eafc7a360a4dc5ed0f4c58601390f7572a1e48a53a75e"
    sha256 cellar: :any, x86_64_linux:      "88819d859e1aab3e788d1e2397689b213e8d37d310a6b1d48510de55a89277f8"
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
