class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.673.tar.gz"
  sha256 "f2af91c7aa3758d3efe551cbe693bdc4d9a6886439fe34c5e919d86f5be4b7c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "565de75a86e70c748327a3a1d40ed3863d605a8148e990a0675325f8437141d5"
    sha256               arm64_tahoe:       "bbbe81acb03cc9162b30fa9b3f2a42998bb02e21722d7903f8bbee57fd759f08"
    sha256               arm64_sequoia:     "020e58dcf785b5e8167ea5958b0da8bed89223d56b864275de343cd9ec135e06"
    sha256 cellar: :any, arm64_linux:       "46db409ddb0dd27087fb5703fb267289805ea326fefaf2b39257c9c87ed0bf80"
    sha256 cellar: :any, x86_64_linux:      "295e9238be9a13db2f15f160644d940a84bae5bd219143264ded3803557e863d"
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
