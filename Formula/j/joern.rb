class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.694.tar.gz"
  sha256 "7ca9ed2e7874860c49100e16e6d1070fd9ae1bf697ab65cf8b1040d9b72b05fc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "bd5e1462e61417d4e780f1edc420cdc9952898ed0c26511282d467a7fcfb1ec4"
    sha256                               arm64_golden_gate: "e102c2a251d30f4f44d7493ca8d9fe38401229d7d842a3205907a0ff1bf1cf7a"
    sha256                               arm64_tahoe:       "3beb0455280924e98387ea7650dfa5f2188104c4d5271b2dc10dc3be17042f4b"
    sha256                               arm64_sequoia:     "e102c2a251d30f4f44d7493ca8d9fe38401229d7d842a3205907a0ff1bf1cf7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "faacbe822187fbf092a4d76e21249a81a970c12d6e7bd97c3a7f0346a89151b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f71c685adfab217e0a8446d5cf043f9672ddd98838651d8897634914a8d853e7"
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
