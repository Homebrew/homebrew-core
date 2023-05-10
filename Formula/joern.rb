class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v1.1.1700.tar.gz"
  sha256 "c6dc508dbdc7871df4e23da8ff47df771c1eb16a757e0f1b3b21e42fbe4f2ab0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cadbb859e8d599f1e665035a7990fe2fe0f675552a68ad6d62af14d9345d853a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3deb9a3f91f3cd6a3b74917bf71156fe38370bcb0088aec86e936fbe4f8f8383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f01bddc19ef4c27551e99de990695be1591a9b4b6ca8c539f34dbbe64b00fc41"
    sha256 cellar: :any_skip_relocation, ventura:        "2581dfd090b5894821b07ecd26748a8f76237f29497600b3bbbf9af492c17ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "b043d5c692bb43c0540593bc983052030f0b0c83a9c0be7da953f0a40face11e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e57dec7a08ee4d494df768241c2432820b4a6cc2a585d95d0a3576c59d51136b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9db56f350f34244213e40b28ee0bd6cccfc658e83c15541a40cbc05f252121c9"
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
