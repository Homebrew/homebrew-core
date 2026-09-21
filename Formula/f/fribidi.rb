class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.17/fribidi-1.0.17.tar.xz"
  sha256 "6949dcde27d41cebad1fd741fcafc36d55a1020d2d872d4a6eb3914caabbada2"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d33019c9cebfdf9b432c1eb85debc62e4d4f3a5ea763bb1b157e9b3a5dbc4457"
    sha256 cellar: :any, arm64_tahoe:       "1933df503db74d65aa5c47dc71f7eedf88692b1e1866a2d98b8422c085f8ef15"
    sha256 cellar: :any, arm64_sequoia:     "c1e62df532f06bf13ebb31df04d7e78645271a00e4261b17594248d16cf7e5b8"
    sha256 cellar: :any, arm64_linux:       "0c0762f498578823db2a45de24b02c8f4cc9c217c708da865cdf0090bcc8aa05"
    sha256 cellar: :any, x86_64_linux:      "1e7ec5073ebe601d951fa4df6ce5cda4aa03bc7bff95216116c29d2ef82dbe17"
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
