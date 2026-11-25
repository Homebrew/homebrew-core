class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/freebsd/atf"
  url "https://github.com/freebsd/atf/releases/download/atf-0.26.1/atf-0.26.1.tar.gz"
  sha256 "95b9755134842da125c58d93582e78d357c6bef11e856c7af2eb5bacbdf9edc7"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/freebsd/atf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d3dc0d5cb8e34c5e3e65e20379c69ceae953ed0ec64d9a9a4e3c7270eb46fd78"
    sha256 arm64_golden_gate: "f37ecdce4e45b82d1c8af1a9dbe7660962ec17df8bb7d9e575bf8ccf96daa44c"
    sha256 arm64_tahoe:       "d8cca69d5ae0bc6b1a09613ab6616707293e75006791e4cb8950b8786d2bde04"
    sha256 arm64_sequoia:     "ec148c31104f1ed1f0aa8cefc3bceb731c58e8bb5410b31608a8c3701779c244"
    sha256 arm64_linux:       "6bcce4a219f276dd34a0e27888570ca404d6eff6dcd5965aae2532700d29d931"
    sha256 x86_64_linux:      "9f586fe1a3a777f71a9f2deb048f8e7c24e3c4ca65d5340229c385090b573a3f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/usr/bin/env atf-sh
      echo test
      exit 0
    SHELL
    system "bash", "test.sh"
  end
end
