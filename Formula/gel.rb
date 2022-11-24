class Gel < Formula
  desc "Modern gem manager"
  homepage "https://gel.dev"
  url "https://github.com/gel-rb/gel/archive/v0.3.0.tar.gz"
  sha256 "fe7c4bd67a2ea857b85b754f5b4d336e26640eda7199bc99b9a1570043362551"
  license "MIT"
  revision 1
  head "https://github.com/gel-rb/gel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb512904278f1fb90fb064290a2b3b3c798be172138f79fe99dc5b0127c31a79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7910ae14c724757ceed042871c75c799e112dc0f96ba7b72ca7ce105c14c2b23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fb1011ea19b25229dd71f48f46b6aab94f5e3eb2699ac50486fb04825cc936f"
    sha256 cellar: :any_skip_relocation, ventura:        "fb512904278f1fb90fb064290a2b3b3c798be172138f79fe99dc5b0127c31a79"
    sha256 cellar: :any_skip_relocation, monterey:       "7910ae14c724757ceed042871c75c799e112dc0f96ba7b72ca7ce105c14c2b23"
    sha256 cellar: :any_skip_relocation, big_sur:        "ceb2f0e2ffb4cc76db737cd86fea205fa20dd25e2c33f367ac1475586137876e"
    sha256 cellar: :any_skip_relocation, catalina:       "df5ac692c53d0410238d619eaeaf3dc8384fa0ff27d3053b8293a56328407ca2"
    sha256 cellar: :any_skip_relocation, mojave:         "197ac248e075981a73fea2bbfdf4d11d10282b7d22ff521424b82fe1ca23a845"
  end

  def install
    ENV["PATH"] = "bin:#{Dir.home}/.local/gel/bin:#{ENV["PATH"]}"
    inreplace "Gemfile.lock", "rdiscount (2.2.0.1)", "rdiscount (2.2.0.2)"
    system "gel", "install"
    system "rake", "man"
    bin.install "exe/gel"
    prefix.install "lib"
    man1.install Pathname.glob("man/man1/*.1")
  end

  test do
    (testpath/"Gemfile").write <<~EOS
      source "https://rubygems.org"
      gem "gel"
    EOS
    system "#{bin}/gel", "install"
  end
end
