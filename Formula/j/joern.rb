class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.675.tar.gz"
  sha256 "3f8f7627da614f0f19dcd08b7ae34886a16a755b63184a1ba58edf6e7476a6db"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "fa9decc1f669d6a613f44a0b1c6f242a1552215b5ad7b0fe0a2c600732d1a56a"
    sha256               arm64_tahoe:       "7f58b376e427d8ee1564e9fad93c15be133fefd0c47502bd0aeda398662c2cb7"
    sha256               arm64_sequoia:     "7f58b376e427d8ee1564e9fad93c15be133fefd0c47502bd0aeda398662c2cb7"
    sha256 cellar: :any, arm64_linux:       "297b7112b6d97adb86ad8c93be0dc4261ab6602ac9aa8af9a0c3360f825404cb"
    sha256 cellar: :any, x86_64_linux:      "c3593b8e217ad7202320b4b941940e9979c8efc9b9f2985f157c0896848f7af9"
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
