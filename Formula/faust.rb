class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.37.3/faust-2.37.3.tar.gz"
  sha256 "f14577e9f63041ec341f40a64dae5e9362be8ed77571aa389ed7d389484a31d7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_monterey: "1bf84ab85632319d644d791ffec7a0535b7cb188aafad015cdf2068a9cbe11ac"
    sha256 cellar: :any, arm64_big_sur:  "2bbdef266d98f44577a3ab668d9efff2c254337a8b1d18af38e346ea88a4e266"
    sha256 cellar: :any, monterey:       "10a68392b508ea5eba3c84568e66417e7e0a6027c7d85795882a1640674d6c3b"
    sha256 cellar: :any, big_sur:        "5a88b886af7e2d9c78be08afb3893e27e68fa371e7d9072360e1fd905bdd2d58"
    sha256 cellar: :any, catalina:       "dfacb1d893c7e379c14a4e865bf59ff4ff829fbc245c5b0e55160d43032f0a6f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmicrohttpd"
  depends_on "libsndfile"
  depends_on "llvm@12"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "make", "world"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"noise.dsp").write <<~EOS
      import("stdfaust.lib");
      process = no.noise;
    EOS

    system "#{bin}/faust", "noise.dsp"
  end
end
