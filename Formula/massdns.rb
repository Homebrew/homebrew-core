class Massdns < Formula
  desc "High-performance DNS stub resolver"
  homepage "https://github.com/blechschmidt/massdns"
  url "https://github.com/blechschmidt/massdns/archive/v1.0.0.tar.gz"
  sha256 "0eba00a03e74a02a78628819741c75c2832fb94223d0ff632249f2cc55d0fdbb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35a82870db0e5f349bacf0d2ef2f596901c75e42ef40db916c7bd37471d8caa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a07f6b26f6625d833864cbfcfea075eace6957ac9a01d99fbb85874f95e995f"
    sha256 cellar: :any_skip_relocation, monterey:       "7365e79331e01ee782e86a393532f2e4a2c3c61b0ddd52dc663b1085814e1435"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cf600e96f9f6e9e693b17894f59e8a14f5cddb2d9690719bbd8553b39b81a0b"
    sha256 cellar: :any_skip_relocation, catalina:       "d24888b27f7a3d0cc3d235e62094d985c378adad90b57939bccf96a14823803c"
    sha256 cellar: :any_skip_relocation, mojave:         "82647b382b8f2c95e7e2186bdc5e85466377c98f09c4320bb6722031114ff7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c1c368ecea9de403a35522764bd47c5f7d5e0560aec3cdea56c4e8cd059c63"
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
