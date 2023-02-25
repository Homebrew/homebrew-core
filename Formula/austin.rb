class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.5.0.tar.gz"
  sha256 "b9cad3670c5f6f750d2c8dc6869a7c5b45fe42305185a0cd3f249e1aa017a7ea"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bab13415d7f55de2a23fb2999f6ea488ecad35f22b7018aa5703a7b695be9b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dab8db7b1dd16ff66fbca2418a97d417eb52faef357cec251c3572d1073b4fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cecb73317bf7a9d1ddd4d7f2f5f8a77b8e7d67460f053c64b749b8c31aef9652"
    sha256 cellar: :any_skip_relocation, ventura:        "5e86c762a55f01f8cfbeb3db004911398a08ace0734780f341ac64a1df806584"
    sha256 cellar: :any_skip_relocation, monterey:       "d06f2a100fc20694a37c473afeeb02b15f105f47c3488e7d1c57fc705547d819"
    sha256 cellar: :any_skip_relocation, big_sur:        "89d0b2e60aad15b293af9f078c86d7cdb6c1c1ebd15d5137b76093003d8b4bfb"
    sha256 cellar: :any_skip_relocation, catalina:       "ba5abcfa7d962bb2ef2c0d3737a2387946b54c5ccbb2a6b4fd76a40cbe116f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1d5d18203da0ac96a98871b73d53c8c511c55afe8a6c38ab7f6f7a68c359ab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    assert_match "need either a command to run or a PID to attach to",
      shell_output(bin/"austin --gc 2>&1", 255)
    assert_equal "austin #{version}", shell_output(bin/"austin --version").chomp
  end
end
