class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1536.tar.gz"
  sha256 "6cfc45727ff6e07da725fa72325c8a9afdf610f3d0149b7aa44d43e00fdffe94"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3988290c4a94ed3d659c348ac05bb111692cbef50741bd74f56b3fd1132e494d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfa8413dbf077f65444a62b59c2e8edcb7c29d2df728321e9ed42f64bdc1c2dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e115ea1c4a564ce17311d9df3696e2fa4f24141bbfd2156839f35da967c988c2"
    sha256 cellar: :any_skip_relocation, ventura:        "cb3201f8b4d79bc33762f23345833948d65854a610a0cf8a2464562c90261528"
    sha256 cellar: :any_skip_relocation, monterey:       "4befe872df9cc0234d8856324552c40f8d7c737b08fdb3ffbb21ad6ee5ae6ab7"
    sha256 cellar: :any_skip_relocation, big_sur:        "50803ea0d2718d161644c7cb51a50dd0216ac5146ad8ed39a2805b53339f69fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9a844029034935633acef2b749a4362964e905a46a7a46a559a35fa81da719c"
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
