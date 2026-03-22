class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.500.tar.gz"
  sha256 "94a363c1f2230f4b1e2c156e5ede8726b10030abeb35985899d83d1aab731e37"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec40692ca8011381b204fd2b0ddab7c79adee5abdb2a3cd7d9c5c00094bdcf79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec40692ca8011381b204fd2b0ddab7c79adee5abdb2a3cd7d9c5c00094bdcf79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "726e887f6d2a04ff92378987eaef3e3864d2c522c34543d434170ad79aa21ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef6dde9c1267d709b64cd6fd297fe125c78f65c53c38770f14d5f180e331081f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "498737d0e49c67298bf050c2b6f8dd53e8ac07024d1fafb5f567ed752b2480a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de452329d7237c64d08d9c0412f1e5dc1b4d9fae87133c6cc3cb2304c4430f19"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
