class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.7.0/jruby-dist-9.4.7.0-bin.tar.gz"
  sha256 "f1c39f8257505300a528ff83fe4721fbe61a855abb25e3d27d52d43ac97a4d80"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f34ca4e7ba7326936b58013d111d284f87ed4e50dc36c8be4845bd63fcc07139"
    sha256 cellar: :any,                 arm64_ventura:  "f34ca4e7ba7326936b58013d111d284f87ed4e50dc36c8be4845bd63fcc07139"
    sha256 cellar: :any,                 arm64_monterey: "f34ca4e7ba7326936b58013d111d284f87ed4e50dc36c8be4845bd63fcc07139"
    sha256 cellar: :any,                 sonoma:         "5d493e13310e0d62cbd06080fb833e032df3c57d59d3b5eb55942552108dbc8e"
    sha256 cellar: :any,                 ventura:        "5d493e13310e0d62cbd06080fb833e032df3c57d59d3b5eb55942552108dbc8e"
    sha256 cellar: :any,                 monterey:       "5d493e13310e0d62cbd06080fb833e032df3c57d59d3b5eb55942552108dbc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c067ecb9bde882fd2ed52125bc977a498827137672dc5456dfb3c3f2ccaaf6e3"
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
