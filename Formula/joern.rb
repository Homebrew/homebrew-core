class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1529.tar.gz"
  sha256 "02b6930669ee0fc13409a570e5eeac026cfce0d35aca20a079c2d779ad787d29"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f61b6f5c568c2075e7f946693ce981a0c967436c2db7259e82bc6f00b24a670"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c7ea44aba44aba1ea1227c283885d6af11806ca5eefac9aa85086c5ac9e5a47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0acedc76d7eeebd8ea0bccff4007c454f085ffab0368d0335a630b50c46338"
    sha256 cellar: :any_skip_relocation, ventura:        "d0ba3cb09cc3cb64b0f5650e0b572287d48e157b10801ab5b4ca6e55e0fc2313"
    sha256 cellar: :any_skip_relocation, monterey:       "2aea34b40f6473fe82b47a18ff0ff4f4084ce3a2949899e037949e779f704c61"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9065993a6b233a72ddc147e335dde09438e1670868e82853107a28625708266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9ace9806a3d987ff10d49f54af1b48996ec2cc2757d486746dd979c95ee4d2"
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
