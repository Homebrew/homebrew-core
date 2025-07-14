class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.390.tar.gz"
  sha256 "49fb972d9dbafb593a5f9c7eed3037fe4aee3a5be25a391ca70de5bd9cc3411a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09151ebed00ee0c163c8ec08c87daebf17268317a8a070035e1fc3d7d5487b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09151ebed00ee0c163c8ec08c87daebf17268317a8a070035e1fc3d7d5487b86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc4ae252fb11a69da60eb43acfc9d12c1267258edf8c3da312b06ae29eafc97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1796e271a79a401804853eaa82b542117ecadb4cdb04185fb7a7b58d9169c375"
    sha256 cellar: :any_skip_relocation, ventura:       "77bdd542adfbfd81e68c3d19128539076e6b197267cbac6e3654220940e08414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53c9a939d4e7c03bdd1b53b7bcd547f1d728ddaad13a9c4dbca31b5a90e96811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f419b6178b40b68ea8bce4cc8f1252adde11be3e158a8d3d8d301d0f070a0e60"
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
