class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ca93fcec2bea0bc26824ef758763c69152327d7bae1893ca3a2069a036c61709"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a547e1f7c9948d9f2960f7c91676ffb9b400fbdbbd524feb4506843cf58e87cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69bd8555fdbf2564c1dbfc5292fe0c2919d4537f64a75787a0dd83d2e162b7e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33c5b48a621ce8072f76170dae149720ab114c699a7f82f7692c9a3b02d6db22"
    sha256 cellar: :any_skip_relocation, ventura:        "d5e6b49055cb007fdbc6a6844b55c3c1c1d00cf9de48f9e39f05000e3eb43a7f"
    sha256 cellar: :any_skip_relocation, monterey:       "3613905239d90fb99c8a69995e97356a20f9a738dcae9c29282b001384f5e4a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e35d86953ef47164ac181d2cfc31ff187822fb690f6c7f952c313f72f02d77d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdb9f4735a12aa737fb56577659ecf6ded302a140af5d3c423c3a1706461dc9c"
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
