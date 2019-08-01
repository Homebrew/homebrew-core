class Cuts < Formula
  desc "Unix 'cut' (and 'paste') on steroids: more flexible select columns from files"
  homepage "http://arielf.github.io/cuts/"
  url "https://github.com/arielf/cuts/archive/18c9c341f0f3679a6bc8b83b4a1f60f9208d780e.zip"
  head "https://github.com/arielf/cuts.git"
  version "20180815"
  sha256 "fda9850588f8090895fd6e68085d6481c8c51ce2eacd5c6dc9736dddf2f488bf"

  def install
    bin.install "cuts"
  end

  test do
    assert_match "test", shell_output("echo \"0 test\" | #{bin}/cuts 1").chomp.strip
  end
end
