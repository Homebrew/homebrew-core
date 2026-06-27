class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.8.tar.gz"
  sha256 "33ea8eb2a4daeaa506e8fcafd5d6d89027ed6f2f0609645c6f149b560d301706"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9e38864bbf2ddb030177f8ddf02c4d21664868ff6002035890da0142873bfb8"
    sha256 cellar: :any,                 arm64_sequoia: "0ad71dfeedbf1ab26589c26d1a6c0ad4da5aaa89fbc6d6c72d0fe68685c3587a"
    sha256 cellar: :any,                 arm64_sonoma:  "94f124b782d74410ba8818770899211c21bf3905c4919258ccdcd92c2569319b"
    sha256 cellar: :any,                 sonoma:        "5a14c7a7ef04c6093b64768074559f4ae29945a578bd5acf9facbb25980305a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93cbef7ef10e2348eee38409550e98123fbeddac4b89e90c698570ffb29c97be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a3272ae4766990b77023294169a3f165ed2f32144a062aa7e83443e3e8bf33"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  # Backport support for nettle 4.0
  patch do
    url "https://gitlab.com/chrony/chrony/-/commit/fee12ec914cce805cc704a4c2804d75b4933ad2f.diff"
    sha256 "fe464ab1e5839472c78d6b60f110c1f9315c44e7caa595b90bbfe42e7e79ae84"
  end

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output("#{sbin}/chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
