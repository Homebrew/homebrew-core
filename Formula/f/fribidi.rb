class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.18/fribidi-1.0.18.tar.xz"
  sha256 "1de5e8073d035388b71d0b2d452b1da1f8caeea8a7702997b401fe1b6250727f"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8509ef7fdecd81cce30f0831067a8f33453f836ec560a73809ccef32d6a8e1b6"
    sha256 cellar: :any, arm64_tahoe:       "ae519b32a32cdee65b95c9f89bbe6d0ad995de5d4e0431f7486e055ffec9ad66"
    sha256 cellar: :any, arm64_sequoia:     "a6b2601a1cfa7c14ecc0b98a2018a5ec1b11a8ca939918442b770964abf601ca"
    sha256 cellar: :any, arm64_linux:       "6554d52eeba10c1ae84a31a72a30a4dbcbe6f33bd88917f8c9ce5c70eafe9b89"
    sha256 cellar: :any, x86_64_linux:      "35a6b2a9fcfe67c0ac51736db8030c27d50e523cf77d83b89253735d7fae370d"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    (testpath/"test.input").write <<~EOS
      a _lsimple _RteST_o th_oat
    EOS

    assert_match "a simple TSet that", shell_output("#{bin}/fribidi --charset=CapRTL --test test.input")
  end
end
