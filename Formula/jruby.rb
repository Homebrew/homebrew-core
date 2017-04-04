class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "http://www.jruby.org"
  url "https://s3.amazonaws.com/jruby.org/downloads/9.1.8.0/jruby-bin-9.1.8.0.tar.gz"
  sha256 "20ac501c99a7cb3cf53ded64ac1b8bb6e0b0f6ba34a41b8bacc9715cd4bb2601"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast rake rdoc ri testrb].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
