class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.4.0/jruby-dist-9.3.4.0-bin.tar.gz"
  sha256 "531544d327a87155d8c804f153a2df3cf04f0182561cb2dd2c9372f48605b65c"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "965d47958ee5ad0812e9831b73870fdf83cb809b3fbb2788f5afbfdcc5547cdb"
    sha256 cellar: :any,                 arm64_big_sur:  "e89a1ecd1c46005bc13e65e0a97835c91d853ec522499e544ba767c0aa12c55a"
    sha256 cellar: :any,                 monterey:       "f18e20c760c97fec3c298e79f1ad2d5a0929a96f0f6500ce9f9fadb168ae472d"
    sha256 cellar: :any,                 big_sur:        "f18e20c760c97fec3c298e79f1ad2d5a0929a96f0f6500ce9f9fadb168ae472d"
    sha256 cellar: :any,                 catalina:       "f18e20c760c97fec3c298e79f1ad2d5a0929a96f0f6500ce9f9fadb168ae472d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65aa8c31e29fcfc34245a54a13e6e5dcd9e6cce38edb4443368f500bcca1aaed"
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
