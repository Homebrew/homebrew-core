class Gel < Formula
  desc "Modern gem manager"
  homepage "https://gel.dev"
  url "https://github.com/gel-rb/gel/archive/v0.3.0.tar.gz"
  sha256 "fe7c4bd67a2ea857b85b754f5b4d336e26640eda7199bc99b9a1570043362551"
  head "https://github.com/gel-rb/gel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7452d45bb894918afcf8c4254910fcbcb29b126eb6376fc0ba77ec25ee79dab1" => :catalina
    sha256 "7b08b9ca28185ab4ae1befb9f62d3d3a0d094f72629c0742b7135a521eac3381" => :mojave
    sha256 "7b08b9ca28185ab4ae1befb9f62d3d3a0d094f72629c0742b7135a521eac3381" => :high_sierra
    sha256 "a4a5e3f1b6eb3ea8511adbf12f9b22482c392616bdd37c801be2fd100a1b886f" => :sierra
  end

  def install
    ENV["PATH"] = "bin:#{ENV["HOME"]}/.local/gel/bin:#{ENV["PATH"]}"
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
