class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.0.tar.gz"
  sha256 "d74fada4c4e22689d08a715a2772e73776975337640bd036fbfc01d90fbf67b7"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c82e741167de74eac4149304bdfd4f96f69623cb651eed7fcf8842b813f1986f" => :sierra
    sha256 "f6968a74913010e7d51c596f8f79e5e7607f461304019b956e4288218da18a09" => :el_capitan
    sha256 "cdaec12a120e36eedc904686d9ce495d859b8abbbbff4df34efea3b0aa885199" => :yosemite
    sha256 "80273d552d43e9b91fcba3fd4e3e1e44f6761e78e7a75e416df8f7d07f6bcd8a" => :mavericks
  end

  depends_on "fish" => :recommended
  depends_on "chruby" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /chruby-fish/, shell_output("fish -c '. #{share}/chruby/chruby.fish; chruby --version'")
  end
end
