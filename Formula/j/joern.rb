class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.260.tar.gz"
  sha256 "e1cef6362b94259465a21346a7668a609bf48c8455a8627aeda8a5b4ed834c05"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)*\.\d*0)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9011dc63ff8f4658d4927dbacf6126d42ee27b1810d4a3bbf209340faa8ef96f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ecdb9627348d9ea005b0cfef373468821d1e2fccf203d72ede87a08bcb2a905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9011dc63ff8f4658d4927dbacf6126d42ee27b1810d4a3bbf209340faa8ef96f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2335a87379c3a5002a30de175aef789006d890a4c7a349a1de5efd09ca8bde6b"
    sha256 cellar: :any_skip_relocation, ventura:        "aca3f6ca4c62cd5b7ed18380e4bec62eba924259dd1dbdf0de15ce710733a5d0"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c398e07f1e533957c483a9763d1ac990b45cfbd59b81d3517056a7acdd8aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32bf5a0667fb2f1f9f94dcb928be2854612fab65911e9af3ac5a48bb25d459c"
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
