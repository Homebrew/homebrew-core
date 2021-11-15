class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.0.0/jruby-dist-9.3.0.0-bin.tar.gz"
  sha256 "2dc1f85936d3ff3adc20d90e5f4894499c585a7ea5fedec67154e2f9ecb1bc9b"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2370b5caecbf6b5ee27699744ee84d7101df917514e144314ef95abad66125f6"
    sha256 cellar: :any,                 arm64_big_sur:  "4e588bf056c56b699fbe79b3f6e3f1726b9a129bd20d7e6132e18e3e7c29ce8c"
    sha256 cellar: :any,                 monterey:       "114711466814ecaea86a7f44df271686c8a453eac705e2c6ab07f327bc3061bc"
    sha256 cellar: :any,                 big_sur:        "b7741941d9b16c003932b4143ccfbfa0fe3e942f9bba3c8ef32f596bc29dcdd7"
    sha256 cellar: :any,                 catalina:       "b7741941d9b16c003932b4143ccfbfa0fe3e942f9bba3c8ef32f596bc29dcdd7"
    sha256 cellar: :any,                 mojave:         "b7741941d9b16c003932b4143ccfbfa0fe3e942f9bba3c8ef32f596bc29dcdd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22af5cc9e3d2a67c04669b80642c56230a0b5ae387deecf6cd1b4c9a9feca694"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast rake rdoc ri racc].each { |f| mv f, "j#{f}" }
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
