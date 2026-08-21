class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.06.tar.gz"
  sha256 "a37192e266742e7fe33ec19a3be49aea7fd4d066887863a6e193fa345bf2e592"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?convmv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f95c51cf5841e30e334f11d1e579e5075e71453bcf4632f5e85455cb901acc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d59b68a858b0dd231b5a56326a0ed13f26522b7d3e220c490689779b6ffd059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc6eb872156f54e09640f970659174fdbcc703bdf3ed10dcd09543074bc2696b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12704ce771827fcbb7967d0a67fa7e4dd5ff5eb774d7307b59f0a6f386e00cf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dc432373d4dc9621367bc0cffc256d2484cd4a55e9d1403b2dfc4bae2d34edc"
    sha256 cellar: :any_skip_relocation, ventura:       "96f7dc349fbdb3646f2c0be800a546714c2c06500de40de309931d199b9dd737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dbc0d946de621b8eafb49874bf80e72b104c1756413ff227c720e470ab53458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dbc0d946de621b8eafb49874bf80e72b104c1756413ff227c720e470ab53458"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"convmv", "--list"
  end
end
