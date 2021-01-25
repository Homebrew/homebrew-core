class Massdns < Formula
  desc "High-performance DNS stub resolver"
  homepage "https://github.com/blechschmidt/massdns"
  url "https://github.com/blechschmidt/massdns/archive/1.0.0.tar.gz"
  sha256 "0eba00a03e74a02a78628819741c75c2832fb94223d0ff632249f2cc55d0fdbb"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cf600e96f9f6e9e693b17894f59e8a14f5cddb2d9690719bbd8553b39b81a0b" => :big_sur
    sha256 "4a07f6b26f6625d833864cbfcfea075eace6957ac9a01d99fbb85874f95e995f" => :arm64_big_sur
    sha256 "d24888b27f7a3d0cc3d235e62094d985c378adad90b57939bccf96a14823803c" => :catalina
    sha256 "82647b382b8f2c95e7e2186bdc5e85466377c98f09c4320bb6722031114ff7a5" => :mojave
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    bin.install "build/bin/massdns"
    etc.install Dir["lists", "scripts"]
  end

  test do
    cp_r etc/"lists/resolvers.txt", testpath
    (testpath/"domains.txt").write "docs.brew.sh"
    system bin/"massdns", "-r", testpath/"resolvers.txt", "-t", "AAAA", "-w", "results.txt", testpath/"domains.txt"

    assert_match ";; ->>HEADER<<- opcode: QUERY, status: NOERROR, id:", File.read("results.txt")
    assert_match "IN CNAME homebrew.github.io.", File.read("results.txt")
  end
end
