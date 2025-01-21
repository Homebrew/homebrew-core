class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.4.9.0/jruby-dist-9.4.9.0-bin.tar.gz"
  sha256 "8d64736e66a3c0e1e1ea813b6317219c5d43769e5d06a4417311e2baa8b40ef7"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90f1d4c62a14003b9e9fb14466f990d60eef3200823d09569c2e3235cc04f4df"
    sha256 cellar: :any,                 arm64_sonoma:  "90f1d4c62a14003b9e9fb14466f990d60eef3200823d09569c2e3235cc04f4df"
    sha256 cellar: :any,                 arm64_ventura: "90f1d4c62a14003b9e9fb14466f990d60eef3200823d09569c2e3235cc04f4df"
    sha256 cellar: :any,                 sonoma:        "96de337118b5728b1da86328c614a03cc927e84ebb8c3d7a6967fcbaee87fa31"
    sha256 cellar: :any,                 ventura:       "96de337118b5728b1da86328c614a03cc927e84ebb8c3d7a6967fcbaee87fa31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bad7e6b6572b85417d3d5f1a22066e6cb3f89c46c86c4aad7ec1a75e530ffb7f"
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
