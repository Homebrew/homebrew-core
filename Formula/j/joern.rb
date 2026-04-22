class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.520.tar.gz"
  sha256 "001ab5795c55c4dfe9d11e17b61a9a3d66e0277b52671008de4cfe2b159696a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1cf25babaf78d7d6c9a5b82f0076681ba13bf404f1587f1f7834bebb9f69a32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4008addd20cc35618025aaecdc8bd793b4f3a0f1d557286c81510921e771b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcf8193687a04a7463854f643623a5bf8497cc84035ca6003b4f1eaff1c23fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "094a11542fb07c3112adb6d210c7d5ba76de7ebf65806b27da431d01bdc8a9d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67216bf04a1e8db0ad0891a3f14fb9f0b0b59719b02bcb04c346c482fc3667d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16349fc60810d4872b9b74b1aa2216b80bc9b15955666aa29a41272497a4394e"
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
