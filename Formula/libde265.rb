class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.4/libde265-1.0.4.tar.gz"
  sha256 "c3f033bd59777624859c8d04a5b7ce4210adbce4a500943d2e211c4d517d0116"

  bottle do
    cellar :any
    sha256 "00c0149398c1b2a0a8bf0890f436ef4c96decbfc1a82139bd0cdabe6d2c277f4" => :catalina
    sha256 "dd0457e307b44dc0c0f2334551c683d266e41172a5a9484de39c2f9a91138fbb" => :mojave
    sha256 "e712786bd62fbf41567a66d76a263caf00d54fc1e83f5a9c9749ec16c303dda0" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sherlock265",
                          "--disable-dec265",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Install the test-related executables in libexec.
    (libexec/"bin").install bin/"acceleration_speed",
                            bin/"block-rate-estim",
                            bin/"tests"
  end

  test do
    system libexec/"bin/tests"
  end
end
