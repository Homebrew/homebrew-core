class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.570.tar.gz"
  sha256 "50b438bf0e7bcde19b3c5fdef6e8062a6655711bfaed6dcdaed1469ac236caa0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "381439d799ebdb250a7fcdf10ed4c0640b430851ebed690dabc21f6d6a5f0750"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b8450534423d132cfe672040523e47b1e84704adb42b07da680c3cdf829632b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a05fefbf92274d7b146a53f0f01ffbc0da9321770bd57aa7264b1d3350c6cd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "037e72d99530e4b642c6e70dfc940c76382add2f061e7b0e669fd048805436b2"
    sha256 cellar: :any,                 arm64_linux:   "722a35f35af95ffade0b3394d850f41e2851fac3df4b0e221ff109a5eaf30042"
    sha256 cellar: :any,                 x86_64_linux:  "0171aad9c0ae8cc806d81da7a40c2a93dfb3fadeac5f1d3877460f271fdf9536"
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
