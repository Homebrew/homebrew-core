class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish"
  url "https://github.com/JeanMertz/chruby-fish/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "db1023255fa55c9a01b06404cd394cccf790d42985cf85706211e5a0dda4fd9f"
  license "MIT"
  head "https://github.com/JeanMertz/chruby-fish.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c4fc2b36d5552646f11abaef2bf3c8f18a3de7c6126e2c1d3ff653c83f095825"
  end

  depends_on "chruby"
  depends_on "fish"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "chruby: #{version}", shell_output("fish -c '. #{share}/fish/vendor_functions.d/chruby.fish; chruby --version'")
  end
end
