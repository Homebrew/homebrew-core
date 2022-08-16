class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.7.0/jruby-dist-9.3.7.0-bin.tar.gz"
  sha256 "94a7a8b3beeac2253a8876e73adfac6bececb2b54d2ddfa68f245dc81967d0c1"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9db194928095e2073ead12e87ca745e33a03fde4c270b89466502dc0808747ef"
    sha256 cellar: :any,                 arm64_big_sur:  "3f3bd805b7d0fc90b141645fb73730fe4a55b89da2b82d767b6c6af6ff8b8d58"
    sha256 cellar: :any,                 monterey:       "2ece1b9be045718d37f4fb29d506a76e16cae31cf6fc4c05521148b5c7a0a568"
    sha256 cellar: :any,                 big_sur:        "2ece1b9be045718d37f4fb29d506a76e16cae31cf6fc4c05521148b5c7a0a568"
    sha256 cellar: :any,                 catalina:       "2ece1b9be045718d37f4fb29d506a76e16cae31cf6fc4c05521148b5c7a0a568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49c0dcbe2c613a8ad0f48c861a0cd84bda656183334f646fcacf530463ad7c18"
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
