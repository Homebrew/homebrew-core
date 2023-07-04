class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.2.40.tar.gz"
  sha256 "cda8601e1f9da00a22d9ca0c352d54a1d6c26b9a8c24e532ac6befc7899e91a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3d1c022d59e6fce2d80f70b2cce3932d3b5587849b1f9d7f7eacfb4f7ed8971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfa646e04fdc0c5e20ce9dcd9c3fb5344cc7fa463577b6df27e1498d5233b7a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f027af20413423c0de4c402d58a7a799770fb9bf53b7ebf0f80e9cec4a1eb8a"
    sha256 cellar: :any_skip_relocation, ventura:        "a2562323fad7a246addbaa2d31f56402a356316c747112bbfad4bfd0624858c2"
    sha256 cellar: :any_skip_relocation, monterey:       "1dee715df9d2b5c60f0b1d20fab8439ff1d526ff5e5d83194fa2498256315304"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c7073e9e1ad52e0e31dbc5a9a335c4873ddb374d368e517c72f8791a679aa0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d58bc997bd87ee1462322af3b0369aad012362e0c9f7f1275987fb8a3a9019"
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
