class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.220.tar.gz"
  sha256 "c149c353ac4d9aa582b011fb8d382eb7f028bf1b54c77c5404720c5cf95734b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2200cfacd2038a6d24909169c98eac11cce45029720033d096e9ef9f1e2c7a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19e9c8342bd4f98c82b3826d814a5ea71c58356bfcc9a987838f2fe903d14e8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19e9c8342bd4f98c82b3826d814a5ea71c58356bfcc9a987838f2fe903d14e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce5587cd81cb3647a65e3cf18a4ec03c99cc4428bbc8e6e6cd261d07aaed91c"
    sha256 cellar: :any_skip_relocation, ventura:       "fd78f53e13281378359d93c5280b8c978742c1109765d13e66636d62a1e0cf4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d02380afb0e04ca8e005780d303d156bcaf1ab9a7d043a918ffa97780f08294"
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
    assert_predicate testpath/"cpg.bin", :exist?
  end
end
