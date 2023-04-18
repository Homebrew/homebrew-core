class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.12/fribidi-1.0.12.tar.xz"
  sha256 "0cd233f97fc8c67bb3ac27ce8440def5d3ffacf516765b91c2cc654498293495"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98d26d50c4443a28950bdedc0fac9a708feb6e79e5f42e9c0622e133381c0056"
    sha256 cellar: :any,                 arm64_monterey: "e213623dac0255cbc254102a53349fde828d9d2a624ad63eb80c8a25da1bf33b"
    sha256 cellar: :any,                 arm64_big_sur:  "70fd8d0bf3cae1b973c8f580159fa8079dc93a050d19d8032ad0f0288c3f4ee2"
    sha256 cellar: :any,                 ventura:        "2517986679f1b2fe4adf24cf187de27f7f26933a6722b97912857ee32520b682"
    sha256 cellar: :any,                 monterey:       "9bf3206533100a9a3a1628d62c29845698e346fd582a44778cb90f9c784c0ea4"
    sha256 cellar: :any,                 big_sur:        "4a9e4b177eca57063df291316e257b8cf5a7d93b52fd52e0e24387487a4cbc1b"
    sha256 cellar: :any,                 catalina:       "65bb28b6d230b5928e6b1a291f53b1c304e28f28b86bcb8c8eb1207e65c30b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89141837e7e5289c0553c17908f7ae7c04140eb5bba8436648f9f8e9b6d842f1"
  end

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
