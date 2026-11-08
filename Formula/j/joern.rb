class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.676.tar.gz"
  sha256 "4a83acdaad3962f09ab319ec5cdf2a73214301aebe50fbcc59fd99f9c0d28d39"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "6fdcb2e0508c6ea08eecd48c138e3490051e60ee624da0f3fdb0455d1e5a61f4"
    sha256               arm64_tahoe:       "6fdcb2e0508c6ea08eecd48c138e3490051e60ee624da0f3fdb0455d1e5a61f4"
    sha256               arm64_sequoia:     "225304b441c9d0177da272b430d1d2b53a7dba08cac9f18f6ce453232258e22d"
    sha256 cellar: :any, arm64_linux:       "911a996fad4ca6e6fa602b2964472bd9a6db2468642133b5fa2589e493230909"
    sha256 cellar: :any, x86_64_linux:      "1f15f39c559f5f53946567e4527444e43b71c1175c63971143847eae801fef73"
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
