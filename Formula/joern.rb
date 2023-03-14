class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1519.tar.gz"
  sha256 "68de3404315f0d4ee1851b7f9300c6cab26016b1e39b0917e9930efbc2b501d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73e4cedde4e6bf967c9d27840d386ed21b1a02bf46ef2b660d3764007f443ae2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11bc5d7ded9b3f6334f95a5b76b72c6e84f1acc4a0bc739b18d44c89aceb0340"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73d4bc09ce1e74aa0f1f36f3b827aa59d86384fdf742762b3c45db8586273fce"
    sha256 cellar: :any_skip_relocation, ventura:        "21f13c5270f6d6e848d8e74f4e1bee11599dc29350901faac1e13c224646b202"
    sha256 cellar: :any_skip_relocation, monterey:       "91d424ba602fdf0840f146ce4d0e3e8dc9fbaae41ef8711d949c13da1865174e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e28b267b27574924138ea1edc297b307211c53cd945b41a2264ec5bccca73238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ac2148a952f3708d77a774c788036774cf33bdbb36333fb773c4aa9f900252"
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
