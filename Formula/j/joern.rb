class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.678.tar.gz"
  sha256 "6c6f5a29026c6da6e0e084a0e5a71f152cf4ca5a787640d46ef452448376c3a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "4fa079cf11302ebcb10f9c293f3916620cb0a144d54e9f2ec7ff585354474b9a"
    sha256               arm64_tahoe:       "f6ee09216a62c76d1fa7bdbc96f5000f49a85afc4b84db036600b05bfdb19171"
    sha256               arm64_sequoia:     "687927209a61f772755884ca85d72622b979c95789a29e7608ba82a07497c4f6"
    sha256 cellar: :any, arm64_linux:       "dc9f5bbbd59504bf5d9ef87caa5bfeaa5087e794a2f51c42864591479130dbd0"
    sha256 cellar: :any, x86_64_linux:      "24d6dcfcb3ab986443be2d19b8d706df1e37603747d1ef2b368844cde2f4af75"
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
