class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/experimental/bonnie++-1.97.3.tgz"
  sha256 "e27b386ae0dc054fa7b530aab6bdead7aea6337a864d1f982bc9ebacb320746e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b8b5896322c3510224ae84f4eee50d2e8012cbbc713d7e2dba59c859ec1f183" => :sierra
    sha256 "4d3c98c842106b28a9ce7de5612600c6ba53d2aea1b4950af942ee56c89cd5af" => :el_capitan
    sha256 "0e262e7f22ad5b31e7aa3eb197c26e3b0b20bda3e4f5d7650b3c6a5771adf75b" => :yosemite
    sha256 "9edb4a622920f753243c3ec9dcf8cfa4e9cea31e56656f6c55004a6d74e8821a" => :mavericks
    sha256 "84cc882f89feb0df9ac06b2f7b3ace5bc817da9bf77b73da2dbb8ca3e1583504" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
