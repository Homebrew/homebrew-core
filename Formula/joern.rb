class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.20.tar.gz"
  sha256 "a054004bfa3b7ffb0ef72459fce1064c6dceaa577db2a94ad7e862da8468a1df"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05ffd1c526166c860b0c98c0fd68b6c6f5bdea5e4b993af40b1d9ae7df5be40c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18a2808aa4f8bfbad792be5d32fdc75a8ca37f96d6bf0f67e0c20cbfe27562d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea9d243408948b0858d20339355657fadbae46f9fe464cd5c112fd96d5fee057"
    sha256 cellar: :any_skip_relocation, ventura:        "4d4c7b870b72bd1585c9c3ba2c7527cb53f93500324136d8e7535949cab55bbd"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae85c1c3f8cb91d25debbafac8b5e140f939ab7f69ba555b468fd089ba2ed40"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab3ac1d135983adbae58f7cba7456f79b1b36b6f66eff14f590c6a95b4bdaa63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a13a3f000e784954bd6aa39dee35edff61b6b53e9c7a775596851201a8d919"
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
