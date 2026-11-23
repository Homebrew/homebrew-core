class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.690.tar.gz"
  sha256 "3c3cabfca0b12c3e9c4de2440638e5bf7e4489f03553e445bfc2e184598599e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "b78b3dde8965e61e7eadfe8ccfcd83c5d42f8e3fed63edab66aa2bbe021ca1ca"
    sha256               arm64_golden_gate: "d9d4ede7f27c571414fd13574e459cf3c4a49d89b87e1c1f820a109ad01858fb"
    sha256               arm64_tahoe:       "49a9da5a43b29e229c1a1f42be8e1242556919b7bc25543cd1e48e4db393413d"
    sha256               arm64_sequoia:     "57a1d01235a5c705cdeebae60c31944d707580368e0e7731821014ec7fdea256"
    sha256 cellar: :any, arm64_linux:       "d52ee1579e78441b4cee902d27f65057a7b2a76ba7d1df17fabd04a771271aec"
    sha256 cellar: :any, x86_64_linux:      "a44db78801738ed21d4ad370a003d7f0446a3e689df248990b8e687894d8241f"
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
