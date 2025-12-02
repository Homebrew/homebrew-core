class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.450.tar.gz"
  sha256 "ce2937a825bb4198658a43b5832f19baa7ca7cc8578c917fce2c44c204f2b31a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a86b33f4ece474ee1ffa5db26fd46eff48a554709841a9d65e70c5547a77f57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3686893adf541bd5375d87aa5376d09f42aad0879a816849f7addbf9ffa7bc3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "598b4e0d0877c3ea039baf89afe640b6bef2d0716fc60ef316c2b7002f923e81"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d76315d496805779700fb33b5bc7daed9c74e15aa8d48e7d53e6b5bdb20ddab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "420387656bd3c60526bd633ebfbf787f1a0074424bdc4dcd04e5c87e048f02bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a0b3e1cb738e3a6498dd8e56144c6fe579080ef074651db1abdcdb70c3c4623"
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
