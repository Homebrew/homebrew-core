class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.120.tar.gz"
  sha256 "1076e9974f2a2c7d104ad6ffa2dc4d23be33ad6affefc437fa56f318bb88e090"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "046d8f8b0f1c0dc8af5ed8b2cbfec75967225f1dd8216bc5e68f5a7964f62c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd0003a5f4b2c45cbe99f584a76ea7e93fe323705c377b937f568bb2efebbd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7973c23314914265969cab63cfd23ed70d2b02d5dba571d8cfdb87af7c0e78d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "10969a2380f332ce65aa826f79b7ceb7f18125601c8b226c2d075ebe4228dcb4"
    sha256 cellar: :any_skip_relocation, ventura:        "4a4289c5274c79399f73089e7a147a3589f0eed57a03007c3e73233420303a10"
    sha256 cellar: :any_skip_relocation, monterey:       "07de575c0c58d75ca9d840c9e0927679696441246989dbfe27b1d0259b9d2248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea68db7704ad279a28f16507af937c6a7a67c14291d6e545aa42fe37013ca67e"
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
