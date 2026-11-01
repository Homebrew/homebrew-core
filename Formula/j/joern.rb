class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.670.tar.gz"
  sha256 "4350bdebfe14cf61a07e23a86592a0bba804e7eeef599b8c368d6b389e99d808"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256               arm64_golden_gate: "11dcbad54f4c76f00dd638b791774e01b2498acd71094642b79d3d699f5b46c7"
    sha256               arm64_tahoe:       "ed6071d54b4afa300cdec3455f569bd7c1ace382fe661f6bcac5b37ed72bcbfd"
    sha256               arm64_sequoia:     "065a0cee24e591517a7e78ac9ad05def5b11dec6835a7eda30146efb9ec2a42f"
    sha256 cellar: :any, arm64_linux:       "3ac42870cdc8d103ba4a732f3fed9836e7dce7156b3fc788c3f06ed007f0cee6"
    sha256 cellar: :any, x86_64_linux:      "e5145219fcccada8d928ff73d2f7803bcb50a61efb5029d0dc9a830fc87a92b8"
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
