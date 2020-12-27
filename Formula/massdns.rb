class Massdns < Formula
  desc "Particle library for 3D graphics"
  homepage "https://github.com/blechschmidt/massdns"
  url "https://github.com/blechschmidt/massdns/archive/1.0.0.tar.gz"
  sha256 "0eba00a03e74a02a78628819741c75c2832fb94223d0ff632249f2cc55d0fdbb"
  license "GPL-3.0-only"

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
