class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.687.tar.gz"
  sha256 "58ee1efe33525f98320eafaa1896011ab350629a2e1815106b7c578e69b70de8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "4b523226e58bdd147f04c2ffe3076c9e38f35ba91a9bd9e523149bad156ca9ea"
    sha256               arm64_tahoe:       "1378a08ba8bc08f33ec16cc3a44504466271c4f8fc1c47b635f5f3b60d3c19b0"
    sha256               arm64_sequoia:     "2c7a845fccd48adbc9f0870cc5d9027322e23d37a8dd0a4643c122cf2ceaaebf"
    sha256 cellar: :any, arm64_linux:       "3cee89e47fc06a80cc984735ea8707f95b2df2cc3d1fcc1e8a230f730635f8ec"
    sha256 cellar: :any, x86_64_linux:      "b4e92c22748b3638fdc2ea36ae4d89aa78659309a07ca6b7be3bc6941db77d63"
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
