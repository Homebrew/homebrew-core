class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/v19.1.tar.gz"
  version "19.1.0"
  sha256 "d9d911b17f31bfe4b1f1879ea1d9fb022339d5886d88ed15a1146e502d606808"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "33f11449a68550e6fbdfdbcf60b275e6e55c3e9c6121df84544bc101c95fee65"
    sha256 cellar: :any_skip_relocation, ventura:      "40bf530791b86dbc0f59f6d1a5aa35780756e7afd5a0f13030d8bdec8c9bc1bf"
    sha256 cellar: :any_skip_relocation, monterey:     "9c2261847967e7814706d5c24cec9fb575a454f011e85202f09821e4eca2007a"
    sha256 cellar: :any_skip_relocation, big_sur:      "a0828549c71f1af934ad53a31c7b291c397eb9fd77e158d2634e32fafe1e8e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "578fa48d0405fde362bcab38eaead31a8bcf4330d81806119e82824d02b08ef1"
  end

  depends_on arch: :x86_64 # https://github.com/byronknoll/cmix/issues/51

  # fixes https://github.com/byronknoll/cmix/issues/50, remove when upgrading to > v19.1
  patch do
    url "https://github.com/byronknoll/cmix/commit/24bf4769f287b1abbd72c9cdff047bd47d9739d8.patch?full_index=1"
    sha256 "1c60e3d051dc1b9da1bebb2a73863314179c8644d9cefc1eefef654debdaf12d"
  end

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/cmix", "-c", "foo", "foo.cmix"
    system "#{bin}/cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
