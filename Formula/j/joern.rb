class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.580.tar.gz"
  sha256 "81c7ae39e66f9a1abc5bddd2f79584015f43509411455cb37bb75af015f9d6ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a301df03f53004ba36024ac55a6441e058ea8fa379b12ddcc2c8ebfd35f22093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "588c5ae32fe004c72eed45a0cd2336c0c56810692f6acac0c85acf28ae74c2ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c22fcedb73e8fb27ede627b4f5cb30c621317f3b767464056b086d46ed26c6d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6804efbb37df344990f90c6103f8924958020a058392fca03adb2dfa4768c1c9"
    sha256 cellar: :any,                 arm64_linux:   "06ebd6bbf5e2843ebb106752439629bd81ffb866afad23d182038a090473351f"
    sha256 cellar: :any,                 x86_64_linux:  "28c26a4bc58c9e2582a26b5413bb0a54ddf500ff0c36af0546379f5e76c6b837"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk@25"
  depends_on "php"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "sbt", "stage"

    cd "joern-cli/target/universal/stage" do
      rm(Dir["**/*.bat"])
      libexec.install Pathname.pwd.children
    end

    # Remove incompatible pre-built binaries
    os = OS.mac? ? "macos" : OS.kernel_name.downcase
    astgen_suffix = Hardware::CPU.intel? ? [os] : ["#{os}-#{Hardware::CPU.arch}", "#{os}-arm"]
    astgen_suffix << "-mac" if OS.mac?
    libexec.glob("frontends/*/bin/astgen/*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env("25")
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
