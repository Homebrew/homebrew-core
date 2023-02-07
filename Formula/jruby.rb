class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.1.0/jruby-dist-9.4.1.0-bin.tar.gz"
  sha256 "5e0cce40b7c42f8ad0f619fdd906460fe3ef13444707f70eb8abfc6481e0d6b6"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ed139e763a3459f068eceeb05770ecfeebbb8607a4a2388214474d861aeed44"
    sha256 cellar: :any,                 arm64_monterey: "6ed139e763a3459f068eceeb05770ecfeebbb8607a4a2388214474d861aeed44"
    sha256 cellar: :any,                 arm64_big_sur:  "6dee335384edc0eb4b4bce6479f39580e14a4a3d5b2e1d7e97e1ff87ccaf7f5b"
    sha256 cellar: :any,                 ventura:        "55b7c950aaac0f4aab7b8ae0d6b88a2a208b9a99d757427c3472cac694a3698c"
    sha256 cellar: :any,                 monterey:       "55b7c950aaac0f4aab7b8ae0d6b88a2a208b9a99d757427c3472cac694a3698c"
    sha256 cellar: :any,                 big_sur:        "55b7c950aaac0f4aab7b8ae0d6b88a2a208b9a99d757427c3472cac694a3698c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c99e308cff2228b0d59be0ff09752ec2981f52ee112ed7779a2800a6f076786"
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
