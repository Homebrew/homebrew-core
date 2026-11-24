class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.691.tar.gz"
  sha256 "8281de519d0c7a6b762df2fa0401bba706c81ca23cb99837679655a84334f5b0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "f74f7944520eda0c46d12eac1ce13daf961050b33e325f41c8e4e1e0ea09e01f"
    sha256               arm64_golden_gate: "b88f157e31a0a0bc2ea1f1b975c3728908e4b54f92720bb1980b2e2c55c6b1d2"
    sha256               arm64_tahoe:       "e6b452d50cbc8f29bc9be1ab6e303e598cde6e29c82e63db820fcf86ac3bed73"
    sha256               arm64_sequoia:     "33d21c4176e7c97a6bc71d38918877b45a2f8eb12153b3ae8d21693caf6bd27f"
    sha256 cellar: :any, arm64_linux:       "aea5fd99ce641e3176d2378cd278abc85b72eb5ffdd661176400ac99d6eb36cb"
    sha256 cellar: :any, x86_64_linux:      "d0510ac3ab362384bbedc3b6efac9d527831d364491bf3c065f114b2a7fdd470"
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
