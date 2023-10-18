class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.3.0/jruby-dist-9.4.3.0-bin.tar.gz"
  sha256 "b097e08c5669e8a188288e113911d12b4ad2bd67a2c209d6dfa8445d63a4d8c9"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b594390aee296d7c8afed2dead726eef25e8c322462ae5bbacf1dc8a7eb1c8dd"
    sha256 cellar: :any,                 arm64_ventura:  "2fd10e207bd093233fcd885201d78fccfb4267e951de84b45260aefe005f6c1f"
    sha256 cellar: :any,                 arm64_monterey: "2fd10e207bd093233fcd885201d78fccfb4267e951de84b45260aefe005f6c1f"
    sha256 cellar: :any,                 arm64_big_sur:  "85b921637c343735924ca3a5983103935ba5a61152ea5d437f46db0a12b73506"
    sha256 cellar: :any,                 sonoma:         "ab59c24dfefe31fc3ab4f0b927d6f067f8f212c1c015f9aa890f021c0b5b7d9d"
    sha256 cellar: :any,                 ventura:        "d802ee86a25b8ad568c0aaacb2e8d0f847c4f8758f0e189d45ac0c4f5c35f33a"
    sha256 cellar: :any,                 monterey:       "d802ee86a25b8ad568c0aaacb2e8d0f847c4f8758f0e189d45ac0c4f5c35f33a"
    sha256 cellar: :any,                 big_sur:        "d802ee86a25b8ad568c0aaacb2e8d0f847c4f8758f0e189d45ac0c4f5c35f33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86e833df96abd9d0336b78d43498cc774b5adefcc36abaa26acb32d544bc0f81"
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
