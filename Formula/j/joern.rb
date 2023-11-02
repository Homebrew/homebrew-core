class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.140.tar.gz"
  sha256 "ca3b2fec0a9249e90ccb6daadfb0c9ca929ab55e359b9818343a5776c2082459"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff4f8f708c23c99d08ccc3c96d1259cbf92cf815c3a94d8cb45ffeeafa6fabfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff4f8f708c23c99d08ccc3c96d1259cbf92cf815c3a94d8cb45ffeeafa6fabfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1f330f28703283abaa5c7a2de5fd68bd4e644d77b557bf1a49baa65e0286d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "97c4ed943579a2c8a6ffefd0721edf7b0d16a13a4a17a4432a253b51d931577f"
    sha256 cellar: :any_skip_relocation, ventura:        "53291eec124395a538f5d97a3fcf8bb2e7042e442073c5ea4b1bfe15cd5f4f50"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1eeaf73cc26819d9fe969282ec7e0fe8d2cb56d51927a8f89757f068df1c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c149a3577c81164424816e0f7ed0c40113f3b17ee9dc30cdb8dc434d7181df4a"
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
    arch = Hardware::CPU.arch.to_s
    goastgen_name = Hardware::CPU.intel? ? "goastgen-#{os}" : "goastgen-#{os}-#{arch}"
    (libexec/"frontends/gosrc2cpg/bin/goastgen").glob("goastgen-*").each do |f|
      rm f if f.basename.to_s != goastgen_name
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
