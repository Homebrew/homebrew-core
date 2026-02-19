class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.480.tar.gz"
  sha256 "8cd66165eaf611d338ffd018e9df067aa6fff93f52e57185e1db8ac711adb6d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28d5c25b8122e2d5b75e7c9eab1c8b93da0bc070277f453b3a9d2ac94ab595b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14f4b780335a2c3cdde3bffcf286291c06cafc97a431c3c4377b2024a13a287d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14f4b780335a2c3cdde3bffcf286291c06cafc97a431c3c4377b2024a13a287d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f530d02a8590bae34605761800799bdf8c706fd689ba0e0c48fdd70c7b88998d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61bf8ff152bcbef8abfc248fc816b10cc5bad54a753de63dd0653a6fb648e517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9269be807fe7539742fbbc28f273a04f0e6d8c40bfe077cd00a77583ad37fc"
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
