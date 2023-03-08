class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.2.0/jruby-dist-9.4.2.0-bin.tar.gz"
  sha256 "c2b065c5546d398343f86ddea68892bb4a4b4345e6c8875e964a97377733c3f1"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1e522176f133e0a46773f2a312c3dcfd7e05c0fc90afa4dcd5ff59cc9e2b0a2b"
    sha256 cellar: :any,                 arm64_monterey: "067be80ded7fc03485dd9fe3b434b4aa19ee066e3457bb81ae79af0d53468c92"
    sha256 cellar: :any,                 arm64_big_sur:  "ab72e0465649df8b331e78751b040c57b8a87d6f98053243381709837b1f626e"
    sha256 cellar: :any,                 ventura:        "a2744041fb8943079156672775e9f17cab1fda9486dfc8e449981927cf1c5129"
    sha256 cellar: :any,                 monterey:       "d5dd2ecde41de4bae42b6647f34c3812e4bab16483070c0f148a1ea8ea939b42"
    sha256 cellar: :any,                 big_sur:        "6616e983905aa2c27cdd651929405f6c921ff4c5a9c7769c2a6fea8e10e6f063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1897fd558bc9322abd66023cc5f244a43b611880b2138734c605f59c0caeba10"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast erb bundle bundler rake rdoc ri racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Remove incompatible libfixposix library
    os = OS.kernel_name.downcase
    if OS.linux?
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    end
    libfixposix_binary = libexec/"lib/ruby/stdlib/libfixposix/binary"
    libfixposix_binary.children
                      .each { |dir| dir.rmtree if dir.basename.to_s != "#{arch}-#{os}" }

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
