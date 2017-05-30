class Eatmemory < Formula
  desc "Simple C program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/v0.1.6.tar.gz"
  sha256 "5f49eadc5462cebb01afec02caa2729d9885e0f0a251399d1e8f62a726cc0a9e"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/eatmemory", "-?"
  end
end
