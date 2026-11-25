class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.692.tar.gz"
  sha256 "2714bcc331180c1e73a6d366fc13449836334283f9644a3b9d857667e272a582"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "2a31547f474a02e10401e3d220ad3d08eb4509e93f6fd6db0cccac755a022c22"
    sha256                               arm64_golden_gate: "59cc27f213b9e78636822c79fa0b4e14bda4d806bcb38676127eeb58be9611d9"
    sha256                               arm64_tahoe:       "3461c9448036c0be4c06c7978f3d661c993355e3b5eed13a6fcb067524516e80"
    sha256                               arm64_sequoia:     "ef89bbf5b7ae3903fda5b257280088da16d28e51035a5eddfdde021b28ef5c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "350afe412514e3c260a9c0b4c968326beb8d566ea46fbdb5f498689e484197de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "38ab9ac57ab372736604d44664b7dddac4cb629c1f6892e3d8efda480f73cf89"
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
