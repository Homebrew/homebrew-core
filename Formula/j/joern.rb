class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.510.tar.gz"
  sha256 "5f320423e6359e31a6400633c50cef0d527be74affcacf8897639f5c0f835291"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7cb52bde56309047c30e0c5097076e28ca436aa2d75fc230890c4072b5957fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9127cd68da7bbbe51e24a2b0532aabe1daeed1cd99c0a20c8e2c044aef3ce32f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a04e63f65b6c8aebf32135b64980752872978814605dbf60fd7cfba53d3526d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ae759d72f5599139ffc33c15804925bec441f9fb7db4a1639db7cb544808bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f394da3bd2daf7544f3360db940349c8481c554747ae6a81ab4e27312039f0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69997e75d81799badaa14aa1f26b5286f345b83e5cdcabbe73613d4fb6d71999"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
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
