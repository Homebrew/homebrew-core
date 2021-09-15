class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.2.19.0/jruby-dist-9.2.19.0-bin.tar.gz"
  sha256 "1f74885a2d3fa589fcbeb292a39facf7f86be3eac1ab015e32c65d32acf3f3bf"
  license any_of: ["EPL-2.0", "GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url "https://www.jruby.org/download"
    regex(%r{href=.*?/jruby-dist[._-]v?(\d+(?:\.\d+)+)-bin\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "b9cbf7f60606bcd04421d60bd03365183d3ee35d9e2fbe07c51d9b12c4234a36"
    sha256 cellar: :any,                 big_sur:       "ea76b9eaa16eb6a20ffc0e440125d22e9e580177e662deaab6b9e821de2394a7"
    sha256 cellar: :any,                 catalina:      "ea76b9eaa16eb6a20ffc0e440125d22e9e580177e662deaab6b9e821de2394a7"
    sha256 cellar: :any,                 mojave:        "ea76b9eaa16eb6a20ffc0e440125d22e9e580177e662deaab6b9e821de2394a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb01de5d760d49ad6731630940ab02f9d8cb2a4ce070de9316f7bce886197381"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast rake rdoc ri testrb racc].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
