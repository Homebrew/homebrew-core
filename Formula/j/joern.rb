class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.110.tar.gz"
  sha256 "aac6a6d59a0ac78b2085214b71febc5f44b5c77b8d902651b611d5f239e2e1df"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f679fb9ba58fc1856461e59f1d323fac278f325105cc7c0ba9ccdf00c9a8b37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25428706149bec0c4a7bd39e7b729fab78da1e127f191080f00915e51c94cf3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c695f4c56def69dd917eab0838a9bb0da012ac7f635b8b0384ea25ddf7c9389b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cea763e573236f800e1b2e3a5d336d78b9b22e149619a9e918c5650c836e6745"
    sha256 cellar: :any_skip_relocation, ventura:        "409781d70e60b6ce7403cca8f9ea466a22dc51af2d476f64ba14ffe3568b5f4a"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd66a6e42ebdf7012e0493f6f83418847de2586a9555ecf4cf9be4dbd0f17a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb818abcde46ea24a75b64bd410e0a49402fd9e81ff6797f260dea8428a1b28b"
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

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    arch = Hardware::CPU.arch.to_s
    goastgen_name = Hardware::CPU.intel? ? "goastgen-#{os}" : "goastgen-#{os}-#{arch}"
    (libexec/"frontends/gosrc2cpg/bin/goastgen").glob("goastgen-*").each do |f|
      rm f if f.basename.to_s != goastgen_name
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
