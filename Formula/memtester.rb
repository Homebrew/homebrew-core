class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "https://pyropus.ca/software/memtester/"
  url "https://pyropus.ca/software/memtester/old-versions/memtester-4.5.1.tar.gz"
  sha256 "1c5fc2382576c084b314cfd334d127a66c20bd63892cac9f445bc1d8b4ca5a47"
  license "GPL-2.0-only"

  # Despite the name, all the versions are seemingly found on this page. If this
  # doesn't end up being true over time, we can check the homepage instead.
  livecheck do
    url "https://pyropus.ca/software/memtester/old-versions/"
    regex(/href=.*?memtester[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "805698c2316c9738d9c7c5de7cf7edce56b7e6f481916204bde28fea90475385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5ce3dde902d08c7d9a271d327f9eee0c017e07937623cf095856fa8313cd882"
    sha256 cellar: :any_skip_relocation, monterey:       "8279cf9cb4562df9ffc10a813904a93d0e01bc454a3ed482a9f5bb58b5308140"
    sha256 cellar: :any_skip_relocation, big_sur:        "5166f804aa60dda7386e22dee840ca0e65989021bae02d7e9b2b57b66be3e68b"
    sha256 cellar: :any_skip_relocation, catalina:       "b71fcf7ef390537edfcc94fcbf61c0118461e4f3d845764847d9bf30617fe84a"
    sha256 cellar: :any_skip_relocation, mojave:         "cb3c13604ee72639b2ef46f0ebdf9dd37e5675a850e92ec5b8f14fa20108c131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc3354dc6b62307ec218bd5f77d41a1fdc8de94056d62407d6a5a6f62a54337"
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
