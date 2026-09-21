class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/hello/hello-2.12.3.tar.gz"
  sha256 "0d5f60154382fee10b114a1c34e785d8b1f492073ae2d3a6f7b147687b366aa0"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4dd2596c2e897c81eae2dbf5030da37b43e797d217f0f0892d39343d0b8c2ca7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae6237e3001bd354783f469d754cee875ee9828910461b85a5803f5990213dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78566829e680af4ececbe5b3aa596c06f9bd0c7b83172a50c4347510a0d8cf0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "90e62f2bc18a74b2ce845e6d5b6b53b96a11e3ce304b83e6278fd3ca0fbed922"
    sha256                               arm64_linux:       "0557a40320fc342b63c4ebca125d81b8dc782576d619800506e00c4d6dffdf68"
    sha256                               x86_64_linux:      "ab40f4006173c63e0d138bdd2b6634ee467f4685c2b130a3edaa712bfee0809a"
  end

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
