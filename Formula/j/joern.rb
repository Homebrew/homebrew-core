class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.630.tar.gz"
  sha256 "4a4bf47ec0ae362e626ee4fc8147df99858c0872939d31bf2ecb73094e36308c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256               arm64_golden_gate: "9df26cf296e4940df86fa09871fb3c87c5157d3eb0763eb788630f74a65c3ddc"
    sha256               arm64_tahoe:       "9fcba87b7b7ad333ae1a121e98560143c1031dfcb9d50e15bf8bbb6ba8b475c5"
    sha256               arm64_sequoia:     "47edf9cc69f85bc57324c4fb9be150976fbd0f2ac5e495c9df5f279141de278f"
    sha256 cellar: :any, arm64_linux:       "1f42d9fff918426f12ff1d47f9d44f6a89a23823b54308e6b8b905ca4f8f4970"
    sha256 cellar: :any, x86_64_linux:      "f911ce9935a91e02db6435392f1503c69d8556ec1649920c3365457f1f292f86"
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
    system "sbt", "stage"

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
