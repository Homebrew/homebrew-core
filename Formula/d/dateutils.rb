class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.12/dateutils-0.4.12.tar.xz"
  sha256 "1e0593116e1a229242255cf890f210cbe120e6f05e9d877faf8d85da675ade1a"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_golden_gate: "86ba6fdf734dc5c4bffcd2c9abd30ce42119423316e913d53673c0f2af269bff"
    sha256 arm64_tahoe:       "5611c984dbc411ba0c4fc552851d3477c04840025efd12d0a2b7b1b6606fe874"
    sha256 arm64_sequoia:     "4bcbff992bf54d1acffbc1b53f297eb969095f3e6ef8862a24b0a8521745b969"
    sha256 arm64_linux:       "15a72b3473ac7875ee8eb35a7a245b8b683620203388eb8c99c130d6e52f4681"
    sha256 x86_64_linux:      "17027d41652de2e5fb5a5dd08092095dd8335195ac662b65afd9267b7d58349a"
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-07", output
  end
end
