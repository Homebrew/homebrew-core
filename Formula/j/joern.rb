class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.50.tar.gz"
  sha256 "bdea7e7e8adab75363bee515d757ba37b60138eed04ac452d5ee71d32ca1b4c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c74b8fa5bd51620b800b915f91fac83c3c8bdff12f131d619c97fba3d7905627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e10e69297280121d25ee67fdf961c0ffdc9f840b682a3c8840ea59030cd84227"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "987ec409c38256e7a3f5ae78313cb87a489a125aaa50d24f37b9062a2a68ae2b"
    sha256 cellar: :any_skip_relocation, ventura:        "84e99cef53e5387ed22398a60426a2cbf9a93a78b06873b7d2eae15b15e26778"
    sha256 cellar: :any_skip_relocation, monterey:       "fc42e796272ec840aff7db2d3ae15fd259c442de1ef7417405dd5f8f3732f6aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dd24dfb17a3e53e1cb1b19e4b5ddc25878e73f9fd85849f746efbc274aef4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d565be8632ca166eb637b9c9c0518be51b8179694766ee68b0bd95471b5eb254"
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
