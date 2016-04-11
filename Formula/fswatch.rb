class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.9.2/fswatch-1.9.2.tar.gz"
  sha256 "e8bcb9018831c353cd85a8ce5fcc427e27bdff8bfc3cace1619f6cda3527d111"

  bottle do
    cellar :any
    sha256 "1302fd01516f7484a9142bd4bd9bffa2beecec9471dece89ed67a76a123ddecf" => :el_capitan
    sha256 "16f086c38f0aae2898e99efb04234c6a075e0a0fdd4418a857b8e22d9b1a9136" => :yosemite
    sha256 "5bd59c4f6700cdbc00b43ed847c1f0f5bad6df04bd4361dfa5e0472682024ae3" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
