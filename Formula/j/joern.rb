class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.90.tar.gz"
  sha256 "abf053caf4749acf3b23a35a844b2a29307fcb982564924cb0c8702ac169537f"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "294e5b3fca02c2d4a6d52c89842e9f7f2e2c68d3a6a89d832f4dee89722ce15f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "294e5b3fca02c2d4a6d52c89842e9f7f2e2c68d3a6a89d832f4dee89722ce15f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883f1a36c5ba0c880753aa1cc1fa36b3b7ace8eea32227407ca72130803af547"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0735faed52e991e7325a4ae31f6265a35986f9589f5e67708301934de2b05e"
    sha256 cellar: :any_skip_relocation, monterey:       "d58769230dbde895ace5ed5ce4349a39eba1338f0a5377f6ac8b28d692dd6cbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57d514b0981abff37183917b16584452b51aa7bbc5a1ced3b4c77097a82e15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2eaedb36097dd42bcc7a969165e76bfdab66c9d48eba70e0b3d33f1ecb2c502"
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
