class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.677.tar.gz"
  sha256 "79b044b1613828c6a59586282670daa90d4070f8dbe8b9ed965ddc1c5721d298"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "42a78d1834fb141e83e6a6a0f754032e6fd597eec2a12fa30ab10e21311be5a4"
    sha256               arm64_tahoe:       "91084acd6e1ce7216ce652c75bad3b762ea6ddcf4ceedacb80a0014ff9c9f61c"
    sha256               arm64_sequoia:     "d126fb02480de04f34ae329cdae819d6c9863dc77a4eeda9a6bba3a30195b355"
    sha256 cellar: :any, arm64_linux:       "71ba423edbcc7d5e00e1f3d970afb0c4a7ed86ac0f6b9c7889e62cf172794e6d"
    sha256 cellar: :any, x86_64_linux:      "8116520b75fb4cdd58f3d792c478598f795b750fd3c9f3da9de570056cc3f7bc"
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
    system "sbt", "--server", "stage"

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

    # Special case for `SwiftAstGen`
    deuniversalize_machos libexec/"frontends/swiftsrc2cpg/bin/astgen/SwiftAstGen-mac" if OS.mac?

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
