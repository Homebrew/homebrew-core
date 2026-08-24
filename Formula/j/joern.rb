class Joern < Formula
  desc "Open-source code analysis platform based on code property graphs"
  homepage "https://joern.io/"
  url "https://github.com/joernio/joern/archive/refs/tags/v4.0.610.tar.gz"
  sha256 "62316e1fdb85c768174958fb39bbd610a1f3e3ab57e6f0574b30632becd1a1f5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12395ba79fcc29a1fe23880ee8e33d3afa64d8d1b1f32a0b2732182009acbeae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e7a57d3a5945b928f4a1c1fbdfc77023e63402ffbb9817b13c55944027b99df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f020b21788b27b764ee927a7ee42447a021e2e1302b267955ce7c63a178cfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "369d055f2d5ee65784a33a9a61a8b21dfac17722ed8c02511b04227bcc879474"
    sha256 cellar: :any,                 arm64_linux:   "5c0655d3ebe516e44166eae915acddd9e5bf91e08643ee7396ef31903b7d7c40"
    sha256 cellar: :any,                 x86_64_linux:  "2c46f1b233dede6c20d0572dbc724bbb78801b3d05b1d4df7251d652acd8cbe5"
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
