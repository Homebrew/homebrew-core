class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.684.tar.gz"
  sha256 "9c8a3405957ff3c913b2a43a2085bbbf81e10fdaaa879cdbbd75737593a29d8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "d9bd44498805ba4d8bd84a4fbcd6ffd4437cbab3c63caf9efa3abb8ba1706fe9"
    sha256               arm64_tahoe:       "16dc084c1f5c12c183db73ef69d6ff2e100f1530e48eda2b3210ef9f2c1111ed"
    sha256               arm64_sequoia:     "983ff590255949dc91c1899ca9a8ca50366c317a5e5ef8e12bf132a400e1cd3e"
    sha256 cellar: :any, arm64_linux:       "02dd9dc19703573c80284ec5a9533e53af7b065ce1bb5d81feaebbf1c5506e15"
    sha256 cellar: :any, x86_64_linux:      "0cd582da85fdd99f102c9416405f35b7800116a9735f5db6e50e0fea6834bfd7"
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
