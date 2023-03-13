class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1513.tar.gz"
  sha256 "5c21182a2e28d91141fd238aae0da258cf1e282277cfaaa55fef68accdc46922"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6abbce1e0272a56e73df1cd8a47eda92b19e6737f214ac408027c17c893d0ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1250a1a9fe9005fe70aef3c9722b7bdba27e250d922938c9e87be9d25a537e2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd3ed69ce8a7d6707d8713f4d493f772a4d8c09dce8cb4ba6f3f6624363adbd6"
    sha256 cellar: :any_skip_relocation, ventura:        "7ebc49e5c8c3eb1c85d88214ccefd0db6ac778366a6c36701c15e82ab7ae3246"
    sha256 cellar: :any_skip_relocation, monterey:       "bed400f024030d4348205a424949b5a0a703dd113c275314751ba0386919d081"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7230c2c9e9ed01997e682486aa10633286b51a1ba105165588aeaee5d0e8d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9e25a37d8e3d179703928c6c1e0b5d669974680499b98ff1cdff34cbf426f6"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    libexec.install "joern-cli/target/universal/stage/.installation_root"
    libexec.install Dir["joern-cli/target/universal/stage/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    ENV.append_path "PATH", Formula["openjdk"].opt_bin

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    EOS

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_predicate testpath/"cpg.bin", :exist?
  end
end
