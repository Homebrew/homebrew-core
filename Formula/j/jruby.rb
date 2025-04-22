class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/10.0.0.0/jruby-dist-10.0.0.0-bin.tar.gz"
  sha256 "427d9827ed23fe6b4d11fe61665c75dd7476ba36a0438376eb310ce2a8d24733"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad196fcad0f3c6a97b69c12fab1f0961c2c94182edca8c5e2918639ec66f3817"
    sha256 cellar: :any,                 arm64_sonoma:  "ad196fcad0f3c6a97b69c12fab1f0961c2c94182edca8c5e2918639ec66f3817"
    sha256 cellar: :any,                 arm64_ventura: "ad196fcad0f3c6a97b69c12fab1f0961c2c94182edca8c5e2918639ec66f3817"
    sha256 cellar: :any,                 sonoma:        "3a5a010bde4c89457722c83401bef605a28ea35b82dd6ce0c387c088ff7e04c1"
    sha256 cellar: :any,                 ventura:       "3a5a010bde4c89457722c83401bef605a28ea35b82dd6ce0c387c088ff7e04c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6df34cf800775713d76d8e689df4792bf5310d8b2e1af249d186a806bc1328c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93de6a0e45595d8a1e47eefa3c6a950c0c915eb9d1a7b0bdf2ee0de028b61743"
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
