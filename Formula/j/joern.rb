class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.440.tar.gz"
  sha256 "67a56e8ade91907a5bf912818a034f43ff8172e6189262a096c480cf8268f039"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52d4e5b578ee557e17b6f61b41fd7d6fb4034d944856fe2bb17b9e7071cfa405"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b1102916eb79d1eb8d16ae0976c5c7c1a70342cc78f24fb94f752a601b231b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "529e068038787445bfe9a3e119bb9d7ca5ac5f4da0be52820a16e74cf7c65c8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "530a4b02442b211aef83bfd64861deb3923779d607077843c01b0d64477f51da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9985058b0ea2c0ca06dc70aab11981917619e280db305378896127b27e829c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089ce9ff505724772960318aec17fe5e6d1879568f3d34a8fcea8603a394d11f"
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
