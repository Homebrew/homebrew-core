class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.9.0/jruby-dist-9.3.9.0-bin.tar.gz"
  sha256 "251e6dd8d1d2f82922c8c778d7857e1bef82fe5ca2cf77bc09356421d0b05ab8"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a89cc258d178316968646cb3efcf35839450555ff188f846258b0bb625a7f839"
    sha256 cellar: :any,                 arm64_big_sur:  "3d399f4aadbf14e1bfa71ca7218bec37acec2990ab0477af8d0a357e7f2887e1"
    sha256 cellar: :any,                 monterey:       "905e462cf60a0a1fc8bd88ba8acf6c60c90a4d9f2bb2a32d278eb142ffdc738f"
    sha256 cellar: :any,                 big_sur:        "905e462cf60a0a1fc8bd88ba8acf6c60c90a4d9f2bb2a32d278eb142ffdc738f"
    sha256 cellar: :any,                 catalina:       "905e462cf60a0a1fc8bd88ba8acf6c60c90a4d9f2bb2a32d278eb142ffdc738f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21bb9a84facefc92cccdc223cef462cfcfc39946eec87a007dad92a4f7c56294"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast bundle bundler rake rdoc ri racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
