class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.688.tar.gz"
  sha256 "41967bf280adc7fbdd4544d934eacb47e68570fce524a0d68ca6f97f927ac6b6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "1daba342bcac74d3e8a1f76cbbae60a7d3fff291a829450104313e76f01b2862"
    sha256               arm64_golden_gate: "3f695c3bd9b64ec9262918c571d21810bc7bd308e0bc11cf8bed18e019c5bf1e"
    sha256               arm64_tahoe:       "1eb2ccce2696d4beef961ed6d57877f931dc43d0eaf7c4d68793f5c4c89ccecb"
    sha256               arm64_sequoia:     "1eb2ccce2696d4beef961ed6d57877f931dc43d0eaf7c4d68793f5c4c89ccecb"
    sha256 cellar: :any, arm64_linux:       "c0254fb8a509b1a3dd07a7c6d857a97a164366ea41074873a6d595047b9a4925"
    sha256 cellar: :any, x86_64_linux:      "53a057df05f293eeec54e3cf17e72866dd4e4ac56daf865c36457d0c08c0c6de"
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
