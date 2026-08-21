class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.600.tar.gz"
  sha256 "6b0fe96fadf53893b369252efc95f7a7ce7ac9169092e016c3b2b382dd302a90"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c13daa79d461fcd04313606a322d9d6c920cb1c69d7c0ccf6ab0735aaf2e22e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7249f3f2e42bde991cc70ed4436b226b21c4fd0df8ffaf700a2d790d5376e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c13daa79d461fcd04313606a322d9d6c920cb1c69d7c0ccf6ab0735aaf2e22e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0c26a521a23d550f69d80a55d90ff4d67cc938d6c621f3b6a8e1c4931265519"
    sha256 cellar: :any,                 arm64_linux:   "4ae730ecb84192009b1fd2e5fd24e7a4e3b9a225c5c70682df2c33b66c278f0f"
    sha256 cellar: :any,                 x86_64_linux:  "842d3e28966ff2b6136959e8397701d6306d69aa695b19cbfc9e7d63ef1f65db"
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
