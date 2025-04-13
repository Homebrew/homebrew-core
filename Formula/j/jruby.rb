class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.12.0/jruby-dist-9.4.12.0-bin.tar.gz"
  sha256 "05c5d203d6990c92671cc42f57d2fa1c1083bbfd16fa7023dc5848cdb8f0aa2e"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d146ced4843359f4e1292a53a3d7275721716ed16045d4b9bf638948034a2258"
    sha256 cellar: :any,                 arm64_sonoma:  "d146ced4843359f4e1292a53a3d7275721716ed16045d4b9bf638948034a2258"
    sha256 cellar: :any,                 arm64_ventura: "d146ced4843359f4e1292a53a3d7275721716ed16045d4b9bf638948034a2258"
    sha256 cellar: :any,                 sonoma:        "c1f32aafec98d8c1e38e0482b40a554adb21c7b05ebb6acd2818e77f0c1e5062"
    sha256 cellar: :any,                 ventura:       "c1f32aafec98d8c1e38e0482b40a554adb21c7b05ebb6acd2818e77f0c1e5062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f40ac999534f5af98d3f99c2fdebc211cc3d8b0bac8ed00e49ed605da58947f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49da0e54dca76b9d1967e3b1aae453618dcfe6f1f04b85ac6d5dd16982ebf672"
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
