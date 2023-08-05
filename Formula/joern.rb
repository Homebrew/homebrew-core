class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.40.tar.gz"
  sha256 "0a6f888b5d6777960bee963e1cc1736a7d84029e565a6588befd4cd6e2310563"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a53047aa8b10aae14a873de8ea84e5f08631d2142dd24133771362a67bd6982"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030176b8a72c4e6febf9d79cd450fe34ca11c6fac22df4dd0195d8d605823bed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eefc2a507f0822ab55f27eb3d747a9660373266b391ceafa22c6470edef52c11"
    sha256 cellar: :any_skip_relocation, ventura:        "62dec30fd834768bbf49bd7bc261afbbdb4fe7b5d5bf03f3415da5fca833cde9"
    sha256 cellar: :any_skip_relocation, monterey:       "e80998dc210648cf767b4819efcc7b60f91cb358b6a81e0fde47ee080bdb69e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5081187ed3c2c2cfc99be5e24bef5a76337757972ab54af2522377a415070439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef4d04eca1283af29bb6302eff5869a04481ffafa000f79164d7204cc657afb9"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm_f Dir["**/*.bat"]
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.arch.to_s
    goastgen_name = Hardware::CPU.intel? ? "goastgen-#{os}" : "goastgen-#{os}-#{arch}"
    (libexec/"frontends/gosrc2cpg/bin/goastgen").glob("goastgen-*").each do |f|
      rm f if f.basename.to_s != goastgen_name
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
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
