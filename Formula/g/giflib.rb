class Giflib < Formula
  desc "Library and utilities for processing GIFs"
  homepage "https://giflib.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-6.x/giflib-6.1.3.tar.gz"
  sha256 "b65b66b99f0424b93525f987386f22fc5efb9da2bfc92ad4a532249aaffbab0e"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/giflib[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bef1f5fb654184cce8af628e3a0c222eeab3c61fcaa4ff169974b22c22f01a8c"
    sha256 cellar: :any,                 arm64_sequoia: "87a14dfa72601220313c1190505c7a4d0426b384a6a2d1ba3c5a36bdc784d1b0"
    sha256 cellar: :any,                 arm64_sonoma:  "513c620b8bcf0f74370b4852fa823f1e29761b843540abfb6b9fa9cd9517994b"
    sha256 cellar: :any,                 sonoma:        "2f33f13f237f51ac1521faa46e71338de79a6fe6c826e4f739388fac3ba510f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ab65a2310db6f6801c33aa8856dad4309bc61868006c9fbac62f8730b977b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e349e61810df032b3fff5eaac4f0db46dcc66580a070b5640a60482d6779bf64"
  end

  def install
    args = ["PREFIX=#{prefix}"]
    # Manually skipping shared libutil due to https://sourceforge.net/p/giflib/bugs/189/.
    # It is currently unused (binaries link to libutil.a) and not installed.
    args << "LIBUTILSO=" if OS.mac?

    system "make", "all", *args
    ENV.deparallelize # avoid parallel mkdir
    system "make", "install", *args
  end

  test do
    output = shell_output("#{bin}/giftext #{test_fixtures("test.gif")}")
    assert_match "Screen Size - Width = 1, Height = 1", output
  end
end
