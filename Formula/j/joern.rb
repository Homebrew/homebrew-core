class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.340.tar.gz"
  sha256 "908b8aecda2a3c90ab82f7c38c7304a85cf15f9056a0987c665b5e462af4acd6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7453f1f7ce8fd5e4273e4a87ee6c4f046a32ed5e8b0c1b164db922f0cf69f81d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7453f1f7ce8fd5e4273e4a87ee6c4f046a32ed5e8b0c1b164db922f0cf69f81d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3c2a4a200c8e684e2317af41ff1315db435bb0406599b6cc693493788579c3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbc38a08a5f918a719bb4cbca190caeaecd1c6e304b6aca48c54558c33b7b45f"
    sha256 cellar: :any_skip_relocation, ventura:       "b1a8be9f4e50a13e88765c50b17e187ffc0af30e7883f65703a93e2b38867f61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b089e834ded2ed33112a9d218c9ab20598e84ed79a8f58ca40535038ca856d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d0cbeffb47a60bf389712450971bcf9a5bf834348cf5fd67e903a6c6994544"
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
