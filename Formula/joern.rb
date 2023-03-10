class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1512.tar.gz"
  sha256 "3cbea7adea926be8ca3b97d76411329646239ec1a33e3af0dc15759f7c2a91cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "582f557d564fba9684b1d50926d98e540b517a67b336ca6c00c4d4b9b95a50b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf86cf2de9f2f9123278bdb0f82f97076321bdbf09985f2ad27901276cd6e376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e74d1e0339e9cda342452adbda562a1e2f456d10518f31b8e9e5558f0cd6746b"
    sha256 cellar: :any_skip_relocation, ventura:        "fee60e5bd95a1396ac875a2b55a26f987d9a2c763b537952782cda7944061788"
    sha256 cellar: :any_skip_relocation, monterey:       "930996e1c8a0a758cf15bd5d3b6e8392121cbaa23191db87676fb669152462f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6bb24352386b2160d0fbf00288badc4e323f9f87d70633f01b6bb14db05197a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9feb5ccef80ed908d1c53a77607cd31f33f231bcec29d7afd15ebec8ed5cbe"
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
