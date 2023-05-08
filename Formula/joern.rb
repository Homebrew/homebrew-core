class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1690.tar.gz"
  sha256 "12b7801550be9e941ac345d8146d7d7e3833245e9ca272e7de2dbb4a00a5a134"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f0d902d00086c8fdee52f20e55fc7e1f835a0b8602107d01ba1c4bde5844d6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c0879a5f8d9f03f975827ed4f30f924c35e68af4fd1e62a9eba1d58b26969d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b7528050b40a17ac3658b1155e9ac9c476e33db7a803cc6dfb16481e069c24f"
    sha256 cellar: :any_skip_relocation, ventura:        "fcc33378403df52df0278f24a53157067ee91287f9e84e7065881bc97a2a1d95"
    sha256 cellar: :any_skip_relocation, monterey:       "082d5b5c3ffdb2e3004d3c38cce9298c015fa546e8fa0d9846e98283d0845dc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5b405bdae045b860912c0185ff19f9cbbceed242e759cb2e97475205965b9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266998a4cc4abaa598b1c67279c192686fee68b77342c2c215600329a9601877"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@17"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm_f Dir["**/*.bat"]
      libexec.install Pathname.pwd.children
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("17")
    end
  end

  test do
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
