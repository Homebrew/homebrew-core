class CunitManager < Formula
  desc "Full blown c/c++ dependency & tool manager"
  homepage "https://github.com/cunit/cunit"
  url "https://github.com/cunit/cunit/archive/v0.0.9.tar.gz"
  sha256 "e39147b48c8163bbaaa5db908277aa376fec5f3b2a5f5edecd1716ab9a95c66e"

  depends_on "node" => :build
  def install
    system "#{HOMEBREW_PREFIX}/bin/npm", "i"
    puts "Buildpath: #{buildpath}"
    system "ls", buildpath
    prefix.install Dir["*"]

    mv bin/"cunit.js", bin/"cunit"
  end

  test do
    system bin/"cunit", "repo", "update"
  end
end
