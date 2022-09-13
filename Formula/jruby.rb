class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.8.0/jruby-dist-9.3.8.0-bin.tar.gz"
  sha256 "674a4d1308631faa5f0124d01d73eb1edc89346ee7de21c70e14305bd61b46df"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad6653ef7b613b5c9ac116baa5d57de46d6d303ee6cfe644c95f9c515872a579"
    sha256 cellar: :any,                 arm64_big_sur:  "6182cdfee4daacc30921790fe458242af3a61265715a2874046a193d7ac54ed6"
    sha256 cellar: :any,                 monterey:       "4ea63fc66b21882092361bea322ae4e7019af22ac24751c4848caaa948a81e11"
    sha256 cellar: :any,                 big_sur:        "4ea63fc66b21882092361bea322ae4e7019af22ac24751c4848caaa948a81e11"
    sha256 cellar: :any,                 catalina:       "4ea63fc66b21882092361bea322ae4e7019af22ac24751c4848caaa948a81e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08cd9811210eec3bfcd817332c63ce0c370789b265bc5429ae34924ab4262129"
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
