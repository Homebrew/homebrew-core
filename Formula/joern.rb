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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0acc659fa699eb5423efc1e94c637a4d002b4a1b409dee6091890981a37b6f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad5e8251e1e6845e30be77453694052a284a4ca4ee61507fea1841885f78e1ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb5006ad70b7725a1e22852303102b95b072b498a4513037f9b2d9680fbf930c"
    sha256 cellar: :any_skip_relocation, ventura:        "513fd8234cf645843fdf85624c8950e7533e2e6a109eb3be97164333bc822095"
    sha256 cellar: :any_skip_relocation, monterey:       "fc67051be9a1e1fafbb77b6c10907ea8ff0f310d98d29656291a674a17fdbd8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4e6d4b0a77a7accbd1ca60e16dd6d40c82cb7d4b4dccac3a94417d7d24fad05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5bf5f3a4a3d542dd89d359fb439dbb2ed71380a378c5c930ae9a71f0f3dbfb"
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
