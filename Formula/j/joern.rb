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
    manifest_sha256 "20bae6afb01915e46c12055e2df6ddca752cc6ec31da29bc13c76c073e240a96"
    sha256                               arm64_golden_gate: "4e36f8639821b6652e7e4cf1d99a95e5af36f2b030bd900f2a2c5a2a04660ed1"
    sha256                               arm64_tahoe:       "650db569582ba3013a9532242e00c896b63cccddeb5f990a35107c2e007d6c0d"
    sha256                               arm64_sequoia:     "6ef3cd5c34714e555349100c6911a74d8f28d99cd49bf8e057d49b7890112f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfff3bce2318b0b909774c02b664e9bf50a12356f75b14969b297b1dd4381cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6415f8a91b8a5fe17fb26b4bbebc58a78556c24dbc9d7ac796a0c34daea0796c"
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
