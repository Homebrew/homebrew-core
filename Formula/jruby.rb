class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.3.0/jruby-dist-9.3.3.0-bin.tar.gz"
  sha256 "3da828cbe287d5468507f1c2c42bef6cf34bc5361bcd6a5d99c207b21b9fdc5c"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "227867b3ebcaaddd621c00b2455d665a81b4c48329c1ed7e1b6d03e4443c44b7"
    sha256 cellar: :any,                 arm64_big_sur:  "ed636b1d558dfa99179e994364a7a4e857c6f76f19808ba9ac387ce9ba366a27"
    sha256 cellar: :any,                 monterey:       "57a054fac4a8352dd894ee5606cf6d78143f0df9eaa5f7c7404dce84dc70a4a8"
    sha256 cellar: :any,                 big_sur:        "57a054fac4a8352dd894ee5606cf6d78143f0df9eaa5f7c7404dce84dc70a4a8"
    sha256 cellar: :any,                 catalina:       "57a054fac4a8352dd894ee5606cf6d78143f0df9eaa5f7c7404dce84dc70a4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df795ec4b9c97332d783538b8e4e729cabb8460a3c04f82f494ab42694319229"
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
