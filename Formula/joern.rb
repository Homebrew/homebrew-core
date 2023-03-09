class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1427.tar.gz"
  sha256 "ceddd43317e2aeb3b7250f4d28a20b866f61b561a32c67930e1ca0b22ddf548a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4efef84d13d9d149d6b3da245dcc413482bd3c0367adcf984432aef23132ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab5858f01c9a8f5e2a0881fe4a69a3321ffebfe3625bac38b5dfc106b9e23d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc1300ade7659d6464dcb86e4fba6874a48c042a80a785e5c52e93afcb68055"
    sha256 cellar: :any_skip_relocation, ventura:        "07222291d8988b0a9a37719bd9b93c981802e77d80f42966a46835373d9afde0"
    sha256 cellar: :any_skip_relocation, monterey:       "e10dd993d1fd0619b8b075c17102b39fffde41a9b29f2d8c5ae34cd342ca48be"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cdc4e9be28aa58cf3effe07422be767de51d96ae48c8c601adca549e0ee583d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7796578486d41c74d3ee1e01aaee4f74219d9685b18da420d2fd553291a3c992"
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
