class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.550.tar.gz"
  sha256 "4257908f3b2225398b407788385bf04a1aff1cf676bb84a983841ec637cba590"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1f56f4fc64d10ff62b64ca8d6af4b76151d0894fb572e7599220e33539b5b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62314e6c6dd8a7f8f4af773a8c6a9a64db2ab062bade91875788938a5540f86d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0d5c02f4ee5a9e54c231a388bc26aaa83395fc0274e9ab72568ee69913e8e70"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ef797be69f2a6556bb976ea9a1580f868e2679e04f6012ad287931bcc4779c"
    sha256 cellar: :any,                 arm64_linux:   "d387e3c106300dd2b3cce002ca3a59e746bf47e82e5e61eb738791865a9dfe90"
    sha256 cellar: :any,                 x86_64_linux:  "dafc203f8497b1f900deb8fcfc00b336829b2f94ed21745be8bef2434704b035"
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
    astgen_suffix << "-mac" if OS.mac?
    libexec.glob("frontends/*/bin/astgen/*").each do |f|
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
