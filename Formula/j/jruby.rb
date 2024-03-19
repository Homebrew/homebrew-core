class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.6.0/jruby-dist-9.4.6.0-bin.tar.gz"
  sha256 "2da14de4152b71fdbfa35ba4687a46ef12cd465740337b549cc1fe6c7c139813"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a501f36b2bff7f3deefad58e0283b5c67c287bb167fb97d25c2026646879d5c"
    sha256 cellar: :any,                 arm64_ventura:  "9a501f36b2bff7f3deefad58e0283b5c67c287bb167fb97d25c2026646879d5c"
    sha256 cellar: :any,                 arm64_monterey: "9a501f36b2bff7f3deefad58e0283b5c67c287bb167fb97d25c2026646879d5c"
    sha256 cellar: :any,                 sonoma:         "1ea80ef8c5205fe75313582343bf71f7bd5a93743ba7608f8cd4fa636eead650"
    sha256 cellar: :any,                 ventura:        "1ea80ef8c5205fe75313582343bf71f7bd5a93743ba7608f8cd4fa636eead650"
    sha256 cellar: :any,                 monterey:       "1ea80ef8c5205fe75313582343bf71f7bd5a93743ba7608f8cd4fa636eead650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ed058e819d3f1b360724247fc2bed7074161c82285035cb9d6a5130b3aa13d"
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
