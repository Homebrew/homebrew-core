class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.460.tar.gz"
  sha256 "7779639c4ae7291f4bffc75381f5aa2185b690dc78e5c84403b43921ae391ba5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e220481db41a6c3cafabd3a1fcdf9256e35c7616faa1753b755fb9adcb6d07c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e7460619a82f082c3f4e5aed61fe37114d67fcd2bcf93f4692853108e0ab42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20793b1d8aabad696182ebee3f79bc73603c0aa1f842d0d512f22e44f0b8ca39"
    sha256 cellar: :any_skip_relocation, sonoma:        "17ecf4d5f0b65838cf4be3bf40f8267e76423861beacc3f780fd7bb231775ddf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "602c3914da170e12c0dbc8ba64a7e3f167f9129f840e8d826b95fe4090087f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7256e46d9aeabaee3ba7509c480a5cade80577bd434292bd5775215b5e110607"
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
