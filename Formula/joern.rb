class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "c7a52af9ef331d0b94c364d77e4be04d04ed10f058693752846ba316f25ca76e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac0bafadd3515072d3320f7537a5687981f855afbc5464072a0856c5e95a4a12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0427d197096f34ca37130e2b3096ca837a5229f670f4c0473c6c2cb7defcee59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33f34ca2e0a6b083270bf75f5be889505c3c58a9e99e5829a976a1bf88f6659a"
    sha256 cellar: :any_skip_relocation, ventura:        "e89ccf270b5f48baba9691945c184d803c630c9b3383cd8362d070686fc45111"
    sha256 cellar: :any_skip_relocation, monterey:       "9849a1dc49b1e19a8f9826f6f657abf80503436d7a6748de366686dfdfdf9a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd4abbe85c8b636e0ef80d7ccf6b9cfb469cb09e1deee10ed5a7ed795ac5201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d593d4d15aff3a69287a3ad590b06d1d43e6984d67b421f8c254d904b6f2f2d"
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
