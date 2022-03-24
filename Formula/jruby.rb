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
    sha256 cellar: :any,                 arm64_monterey: "e022e3dc4dbc12d276aa99270abe8338d020f493e2f0e6b00b833b9faa496a59"
    sha256 cellar: :any,                 arm64_big_sur:  "a05511fe1054255459898272efc6a83e4a8a02b229dcd12d0fbe4d8faaa9c3dd"
    sha256 cellar: :any,                 monterey:       "9674759c6995bc806f494228416f8bbe67f5df3f40f54bfb7f2071c4f43b3c53"
    sha256 cellar: :any,                 big_sur:        "9674759c6995bc806f494228416f8bbe67f5df3f40f54bfb7f2071c4f43b3c53"
    sha256 cellar: :any,                 catalina:       "9674759c6995bc806f494228416f8bbe67f5df3f40f54bfb7f2071c4f43b3c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8873fb47a4f28318b0f4324ac9dc1ee336edead5efcff358ccfc6999e0f7944b"
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
