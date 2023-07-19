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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f20a4855c995bd75013a1a0267e07882aa95cf25d00b407b8980a3cd4066afd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31a816f94eb9c3eaabb9d3ae0a2d467e0b412faa632b15a531d58dce4c5aca1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e96a2697a3c44db72ccff5da28360b03011e74ab74f42c28c3f166632f18e43"
    sha256 cellar: :any_skip_relocation, ventura:        "c6c45fad42e1043ecd787f4a0cf3c733b056f774972ea0e4e2e6c3a1f8700124"
    sha256 cellar: :any_skip_relocation, monterey:       "c210287b796f963e8bc36973c4d70e6289e0dc9fbdeec86a6697293938ab54bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "abea7f56ccc74074e47b136cc58b4aa8261e89f981a7fe58ceb14f785f9fa01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5bf194ff4c1b01c4b17b027b8c64865ac4613d2eab7262af28d8e9b8fe0a1cc"
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
