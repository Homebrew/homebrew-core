class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-692.tar.gz"
  sha256 "61300f603798ecf1d7786570789f0ff3f5a1acf075a6fb9f756837d166e37d14"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b722c9aa81a00fae94f5db080f405fe169691d739adfe87773538f911b4f7f6b"
    sha256 cellar: :any,                 arm64_sequoia: "49025d79f5e34f8d10a247b84c108113473d7bc4286f3cedcfdf527f6d7b006a"
    sha256 cellar: :any,                 arm64_sonoma:  "d3ad99fc4a0d87f3b9d8fbb6ae632f9b346edcade504df137b237c8e2feaccbb"
    sha256 cellar: :any,                 sonoma:        "11411cbab4a546b0017adcc73aad460a36698512f8c7db96e7a483667cf8ccf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aa23eb672f228b03513584c06a12a182bfb31bc48ba23bda1d46b3e8c7eaba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ebb640487e5fde5b887326fe22373eafc0af64bbc9da3ad9d03a5d65c8e92b"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system bin/"lesskey", "-V"
  end
end
