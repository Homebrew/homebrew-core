class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.11.0/jruby-dist-9.4.11.0-bin.tar.gz"
  sha256 "cf4067bdc3a6ab518c786588e2486adc047b9cea0b96a43218b03ac651d26e11"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d29112c3d437c467d682403e7c4d1f8b2f0f53f5099e61831d1f721741c56e67"
    sha256 cellar: :any,                 arm64_sonoma:  "d29112c3d437c467d682403e7c4d1f8b2f0f53f5099e61831d1f721741c56e67"
    sha256 cellar: :any,                 arm64_ventura: "d29112c3d437c467d682403e7c4d1f8b2f0f53f5099e61831d1f721741c56e67"
    sha256 cellar: :any,                 sonoma:        "a0c37585cd19fb7aaa729b436d1e2e6dfcc96af3e75404db4f107b7276a93cfe"
    sha256 cellar: :any,                 ventura:       "a0c37585cd19fb7aaa729b436d1e2e6dfcc96af3e75404db4f107b7276a93cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbc2730462aacbb4344ad57c859ad1981b71945f805d862286a9f435163d40b4"
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
    rm_r(Dir["lib/jni/*"] - ["lib/jni/Darwin"])
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
                      .each { |dir| rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}" }

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
