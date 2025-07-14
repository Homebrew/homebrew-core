class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.0.1/jruby-dist-10.0.0.1-bin.tar.gz"
  sha256 "0ba34ac5dfec7c22659b14db668a06284db7fc1c820c49c04b92271a6636bafb"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c82c17f18e1078d370cb8ca36dce63593a500bef026a4367a76e18919d909818"
    sha256 cellar: :any,                 arm64_sonoma:  "c82c17f18e1078d370cb8ca36dce63593a500bef026a4367a76e18919d909818"
    sha256 cellar: :any,                 arm64_ventura: "c82c17f18e1078d370cb8ca36dce63593a500bef026a4367a76e18919d909818"
    sha256 cellar: :any,                 sonoma:        "592788c3ca665d10bd368ad18aef56ee21ea79b799c05122027c9e29fc7b958b"
    sha256 cellar: :any,                 ventura:       "592788c3ca665d10bd368ad18aef56ee21ea79b799c05122027c9e29fc7b958b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47a46c4290e0a4645eca1156283f62dd5d7cc565bff0c3cf9b00eb714afaed54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3412f241bda3335c86a77ca999e6460c41a90a698135de8c2cbd289fe1b8c4a"
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
