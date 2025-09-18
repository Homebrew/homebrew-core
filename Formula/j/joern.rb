class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.420.tar.gz"
  sha256 "48d2f3c87a0ab192ebcee9613f7bd65a0a3c0fc11f40b1a95e802f396c710a71"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3f38fb9fa56e819666a8000a754f902ec98f9fe741be6046335e16261188bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "225888d885d65fcda8089530f3d2c4cbcfc4fb35e6effff3ee9c5c12b05e6a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "225888d885d65fcda8089530f3d2c4cbcfc4fb35e6effff3ee9c5c12b05e6a56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3642f836a1fce23ee0cd147d7ad234a020095954d8f236db9aa6600890ecbb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dad449fb23b0c0a2868ce454cf2b7da755792a3681ef53066f26b0d5e896472c"
    sha256 cellar: :any_skip_relocation, ventura:       "03272921877abd9f81edc5425e51b8afbb738e0cdafaa707371f515c0bbc26d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f1ece03b0387820325cbed2a67b811d50650b4859ecb9cb7888319d8410a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f18152198303f593a7d9d4c2b2acc0e3fa5b8ad0e7fdb69359796897cf2bf00"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  uses_from_macos "zlib"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    libexec.glob("frontends/{csharp,go,js}src2cpg/bin/astgen/{dotnet,go,}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      void print_number(int x) {
        std::cout << x << std::endl;
      }

      int main(void) {
        print_number(42);
        return 0;
      }
    CPP

    assert_match "Parsing code", shell_output("#{bin}/joern-parse test.cpp")
    assert_path_exists testpath/"cpg.bin"
  end
end
