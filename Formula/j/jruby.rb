class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.2.0/jruby-dist-10.0.2.0-bin.tar.gz"
  sha256 "b8a026f38aa98461a04ed0aa0b20891ce257ecbe53e124719ce9ee5b804525f1"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ff9e65ec790dbeedb0a41315ef7f746925be0c07594954f4b9c5d28d3745ade"
    sha256 cellar: :any,                 arm64_sequoia: "4533bcfbb2de5a18e4ca5c3818ae7d0d6469fe0497870825e9bc63eb83787d20"
    sha256 cellar: :any,                 arm64_sonoma:  "4533bcfbb2de5a18e4ca5c3818ae7d0d6469fe0497870825e9bc63eb83787d20"
    sha256 cellar: :any,                 arm64_ventura: "4533bcfbb2de5a18e4ca5c3818ae7d0d6469fe0497870825e9bc63eb83787d20"
    sha256 cellar: :any,                 sonoma:        "7b0dafeb94e91c3eae2ef5b7503166dafcbaeec4d40b61b56ac059f70d77e107"
    sha256 cellar: :any,                 ventura:       "7b0dafeb94e91c3eae2ef5b7503166dafcbaeec4d40b61b56ac059f70d77e107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5894ffe9d19c1b6ab847448d2566b5e20bc8242d0f34e00c4e615207d482c6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368c33ad9367cca9ed918a31d2ee028ea860b8a6885f47366647647f177561af"
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
