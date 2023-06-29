class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.2.30.tar.gz"
  sha256 "c23172e6e188be05136da81d4eb51a2f5f9981c32f826e4e47fd65f1ec69d0e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2437ea4416c0f77d382462393614b9f20362f526e84a412b5378e527520680f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b0c28c6e8d010fd48885009194d9fbc452c22673afc533c6a51b44ab2a8d19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef610ec9b7edf9419a5b78b5e86536cab154c09aa1557fb6b688e9feeaa25b78"
    sha256 cellar: :any_skip_relocation, ventura:        "9726ae7f8ade814dcc3f13a48c913948628e54f8b8266e78edab7d0836e5a08b"
    sha256 cellar: :any_skip_relocation, monterey:       "ea7643940d5e31e2eb1b1314d81bc7e51d9ddfc2108ef9f4a7a8604f314be0c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "703fd65473c19c4b0d2d99c6888958f22f10194f4d60b264eaf6c8d79c6b31f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e961b34ac584f459fef862a4116cc84b1df48c2951beb0f7038b3c4cb3c06676"
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
