class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.0.tar.gz"
  sha256 "d74fada4c4e22689d08a715a2772e73776975337640bd036fbfc01d90fbf67b7"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c787e0ccf157727bd9013f056484b09bdd698ffbe5e417d9b1b3979844bfb0cf" => :el_capitan
    sha256 "88ab2a3351b19ae8d7f625de2faa39c261a3c43ba6c8940c61f172e937e62651" => :yosemite
    sha256 "d56f48b0a49d0c381bffc28ffe320019b89a87a708ec51f24218a0911104bd78" => :mavericks
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
