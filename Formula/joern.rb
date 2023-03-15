class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1522.tar.gz"
  sha256 "bd8d2281ad4c990ce48e7f742aaae102f175a00c01138677d876be4cbd63b4fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6a832fbdbecf3546d5207ad8f27f07d43adb99e79fe08509257f60574a19c85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d2a1d433cf94f6fc1eb7e111bb0ea5a83db3aa14c0b1a043721ffabdb33bcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b797c7f4ee16664300afa46b5a6993c54bfa752f232d96c7bc13c7de0966a80d"
    sha256 cellar: :any_skip_relocation, ventura:        "bc9b799e4d063a389f9babc8c092f8007a904a3ffbe296b3be45807f9dba4cfc"
    sha256 cellar: :any_skip_relocation, monterey:       "3f3ae5460d6299af8cd32f938ed866c3d75e9fba5b57788627fa360315f1c10c"
    sha256 cellar: :any_skip_relocation, big_sur:        "402c0e34e1d3568ba5d5fbd0d6eaded61459d7d8bf5b1c30c029ee88d7176272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72506b7f0a0339a6a91e42b525160f47ab6e0884ffe51ab115f12a7f90f678a2"
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
