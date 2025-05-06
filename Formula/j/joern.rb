class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.350.tar.gz"
  sha256 "6db653308c64adebbeab897e669d2694c23da74c199c46fac1ba639dc13541f0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fa1e17efad83113128dd5c3e5b50fb8c97bc1690c99395e450a6e731dea1f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa1e17efad83113128dd5c3e5b50fb8c97bc1690c99395e450a6e731dea1f13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9568db3c6f0ac665f590321bce14af3de3f248c40bfdb3d9d76f41b321e2cc04"
    sha256 cellar: :any_skip_relocation, sonoma:        "c240e39dbf2299dc801f3e1a8508b08653fe71fcb0e34e9c6fead688bc240b7f"
    sha256 cellar: :any_skip_relocation, ventura:       "cc5758d8ed9b0189497fbe4840690028a872ecaef3b08b9beac403afb40b7cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2bbbb2f2a0274e67f3f49eb64fa7d434626256521310d49563fe7bff302d7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a616205aa0eade3cb2dee3616c6928841a5138109c1e8b5e514ce5657aea3b2"
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
