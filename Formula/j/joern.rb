class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.260.tar.gz"
  sha256 "e1cef6362b94259465a21346a7668a609bf48c8455a8627aeda8a5b4ed834c05"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a386808e0e0942370582cd3d9aa6aac024eb7e0ff3e0511161028e3f7ec380f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53ff3378b6b89834f687f4040e90961c21c96610985d68de0162ca3e425becc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b60bb59047770d4e8e70ec865f7461b4747c69768002443f5c5eafe9447bed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f037ffd828820a6bc0e2e857b217ee058405fbd4c646d32beb938bf373af0ac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "91f3a5321b0e422423b9a7f3f3c166ae7246b48309e9e512fbd8aa18f840dc87"
    sha256 cellar: :any_skip_relocation, ventura:        "a2f804d1e7e9e98a08fdf57aa3641126d01df8be9934c66f80476e9f02085de1"
    sha256 cellar: :any_skip_relocation, monterey:       "bef305b08a69e86fb009ab3186d9fd094a19ae04c7afa8d35a7910c5b24f3c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebf4ab2415b48582b72dd383a7a98127f02fa79056c4974e140e76bd83cfb63"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
  depends_on "php"

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? "astgen-#{os}" : "astgen-#{os}-#{Hardware::CPU.arch}"
    libexec.glob("frontends/{csharp,go}src2cpg/bin/astgen/{dotnet,go}astgen-*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(astgen_suffix)
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
