class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.2.0/jruby-dist-9.3.2.0-bin.tar.gz"
  sha256 "26699ca02beeafa8326573c1125c57a5971ba8b94d15f84e6b3baf2594244f33"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d74a733c36f2ca87ec9636140f3b7faf4c8603ca154ff83124cd751a4f3601f9"
    sha256 cellar: :any,                 arm64_big_sur:  "6dcf340e69824cf06256e30d4da376082286f97927bbcc8ce4cf4229cafe02fa"
    sha256 cellar: :any,                 monterey:       "b3f81064a42a232096dffaa39095c81f80399289903b9c26884db588db03c060"
    sha256 cellar: :any,                 big_sur:        "b3f81064a42a232096dffaa39095c81f80399289903b9c26884db588db03c060"
    sha256 cellar: :any,                 catalina:       "b3f81064a42a232096dffaa39095c81f80399289903b9c26884db588db03c060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce2a980edb9946bd83610aa772b6d95549bffb2161300365107b0c753a4fb9e"
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
