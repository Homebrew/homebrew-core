class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.3.9.0/jruby-dist-9.3.9.0-bin.tar.gz"
  sha256 "251e6dd8d1d2f82922c8c778d7857e1bef82fe5ca2cf77bc09356421d0b05ab8"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d98703ae0951da281bd384320f5b0559d16d6495f42e02532abb84a5af635bbf"
    sha256 cellar: :any,                 arm64_monterey: "d98703ae0951da281bd384320f5b0559d16d6495f42e02532abb84a5af635bbf"
    sha256 cellar: :any,                 arm64_big_sur:  "efca1f053f58c41f50a421d3da5735c41c1f46577c4a82833ea23ee898f8fab5"
    sha256 cellar: :any,                 ventura:        "4cfa81cd683b6196188b607812b160bdd502472dfc229388a9c28d3d80ad906f"
    sha256 cellar: :any,                 monterey:       "4cfa81cd683b6196188b607812b160bdd502472dfc229388a9c28d3d80ad906f"
    sha256 cellar: :any,                 big_sur:        "4cfa81cd683b6196188b607812b160bdd502472dfc229388a9c28d3d80ad906f"
    sha256 cellar: :any,                 catalina:       "4cfa81cd683b6196188b607812b160bdd502472dfc229388a9c28d3d80ad906f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3da658a74a7bda127be3e2636b167593be8e28f141b0af212c1742887582097"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast bundle bundler rake rdoc ri racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Replace (prebuilt!) universal binaries with their native slices
    # FIXME: Build libjffi-1.2.jnilib from source.
    deuniversalize_machos
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
