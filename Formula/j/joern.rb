class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.530.tar.gz"
  sha256 "8709cf520a22c233793604c6b47706072767a8743821e772094d52bc4538e458"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e8384b96aaadbdeae4c28e621f0521a6df116204407312227194cd098775f42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d682f55d05285070181b6d3a47e1a73a60f123c19da5736ccdc0b6579b43690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0ec1172354931b70c8c6caaba874f803f9d2f0e3b1ad9832b30439e145f79f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "292246fad160ecd4d9aacd14a5ed5c0ea5f01d8d997d2ef8996b96179ad3aafe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f13503a224d5e111af0a38cc91ffd8f6ddb71ef5888dd1eb7be2afa4b5071777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1f0c972f4a5c6e569154ae76cc59170cb2538ce8467202d6c59b6dd4a436078"
  end

  depends_on "sbt" => :build
  depends_on "astgen"
  depends_on "coreutils"
  depends_on "openjdk"
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
    libexec.glob("frontends/{csharpsrc,gosrc,jssrc,rust}2cpg/bin/astgen/{dotnet,go,rust_}ast*").each do |f|
      f.unlink unless f.basename.to_s.end_with?(*astgen_suffix)
    end

    libexec.children.select { |f| f.file? && f.executable? }.each do |f|
      (bin/f.basename).write_env_script f, Language::Java.overridable_java_home_env
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
