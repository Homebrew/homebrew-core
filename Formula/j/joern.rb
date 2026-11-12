class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.681.tar.gz"
  sha256 "27a082d8db2960483d14eaea6bedbd1d4da83f15e3f053337c486d5eb6a94060"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "9ed245085e70f279951e0d1fb3fa96e14952de0935a12eba88b333158562b6cb"
    sha256               arm64_tahoe:       "e6debf7218fb7faf8dbc86de089fd30d7879a4b97c3c964286bff7c2696f64c8"
    sha256               arm64_sequoia:     "b810b07b58ce468616251473ea9f4876148c4244cb30bbb013c076a08dabd62b"
    sha256 cellar: :any, arm64_linux:       "011f797697f7410c27ac6d57735924922204907a136ea93990db4994a52ee3d6"
    sha256 cellar: :any, x86_64_linux:      "14c56ed58e99264315918a5c38663308d309a191ebb53506d41ae24009c74b42"
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
