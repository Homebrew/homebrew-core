class Fribidi < Formula
  desc "Implementation of the Unicode BiDi algorithm"
  homepage "https://github.com/fribidi/fribidi"
  url "https://github.com/fribidi/fribidi/releases/download/v1.0.11/fribidi-1.0.11.tar.xz"
  sha256 "30f93e9c63ee627d1a2cedcf59ac34d45bf30240982f99e44c6e015466b4e73d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7c104d645d36d758001c381266aaa20ac40e0fc1591c02ae8d2310e8ca21109"
    sha256 cellar: :any,                 arm64_big_sur:  "d80b767910f47f85b6fefc38a2742d520396f148b8290614b16328704f7c3bf4"
    sha256 cellar: :any,                 monterey:       "28ddf160c24bea077a57dbd389a4e0ff44235fd04aa74335fcb043ab36b30fd4"
    sha256 cellar: :any,                 big_sur:        "434c488a27dca39fa4fab0644cb9b2f495ea4f839eef63587d0de715a93a6f12"
    sha256 cellar: :any,                 catalina:       "9ae1580fef75c9d665f5723200d7987b07674c452e2c236dae33e12a8cf16324"
    sha256 cellar: :any,                 mojave:         "3ef3b5f32b31fad3fb8dc39a559b24abb04cf46c9b29303285eb160d1f4ed19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f82a49f101fe666c5085302138ec5899e51c9346733149f4d872a9c468b7dcbe"
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
