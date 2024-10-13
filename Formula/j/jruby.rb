class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.8.0/jruby-dist-9.4.8.0-bin.tar.gz"
  sha256 "347b6692bd9c91c480a45af25ce88d77be8b6e4ac4a77bc94870f2c5b54bc929"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "84e37f6890b8d70f4b780807c0f54a17ee73b13059a976a7565bccbbb121d3d7"
    sha256 cellar: :any,                 arm64_sonoma:   "e286b22b4d2ba7e6c4059714851c7f45339955164babebc29a4c857ba51c396b"
    sha256 cellar: :any,                 arm64_ventura:  "e286b22b4d2ba7e6c4059714851c7f45339955164babebc29a4c857ba51c396b"
    sha256 cellar: :any,                 arm64_monterey: "e286b22b4d2ba7e6c4059714851c7f45339955164babebc29a4c857ba51c396b"
    sha256 cellar: :any,                 sonoma:         "d187c909fdf179e58778aafab5f22fe3e43d53eb3a2e5b4b32ee2ec413a3f98b"
    sha256 cellar: :any,                 ventura:        "d187c909fdf179e58778aafab5f22fe3e43d53eb3a2e5b4b32ee2ec413a3f98b"
    sha256 cellar: :any,                 monterey:       "d187c909fdf179e58778aafab5f22fe3e43d53eb3a2e5b4b32ee2ec413a3f98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33d9b5d14ab530ea61e55a81c85b93fa3038cd3cb3808b4131476f88f9b2d1d"
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
