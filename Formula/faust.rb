class Faust < Formula
  desc "Functional programming language for real time signal processing"
  homepage "https://faust.grame.fr"
  url "https://github.com/grame-cncm/faust/releases/download/2.40.0/faust-2.40.0.tar.gz"
  sha256 "0a8170ee8e037ee62f92d71ad8a5c3c4a9bfee5a995adfc1be9785f66727e818"
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

  # Fix parallel build of Make.llvm.static
  # PR ref: https://github.com/grame-cncm/faust/pull/728
  # Remove in the next release.
  patch do
    url "https://github.com/grame-cncm/faust/commit/c0e82fd2e261bae7b4614c2cee7f2e1d913cdb4f.patch?full_index=1"
    sha256 "6beaac00630c8d6947e6e67b9e0b0ac45f573cd44aac3de4a347715127eb3ba9"
  end

  def install
    ENV.delete "TMP" # don't override Makefile variable
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
