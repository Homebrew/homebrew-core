class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  # joern should only be updated every 10 releases on multiples of 10
  url "https://github.com/joernio/joern/archive/refs/tags/v2.0.70.tar.gz"
  sha256 "48657ac34c473d595c38312077f1ddd21f608d61fbbbb15ed0b6ceb429cebe36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0f6c276380c2785856ed7798486b16fe7d753cd0c273e44cfeafa72fe01ff97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a78a5e91f8c5966ea052ab92392734cab57a58286ea594076508f3f10bc5b904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a44339d6403f58fb96eb48279f4db0984b3f6f94f94b8254afb1feac2bfaec2"
    sha256 cellar: :any_skip_relocation, ventura:        "98725537c30dbaf14cad4438491eaf2d347e0921f6d44f402a29a82f4baeaa06"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb7320ddb9523fbf5d0728e990be2e50adb1af590359413c7a433e324cb11f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb752a37a751b60e9360f62d3da624945390c2874c6b0ad6e7332202ce234ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bdb77ef45e01413e4254afeefc3fecb24399850a33626b2a27705cfdda57c26"
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
