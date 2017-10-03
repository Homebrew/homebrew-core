class Pspg < Formula
  desc "Postgres Pager"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/v0.3.tar.gz"
  sha256 "a1559a86c8d6a7c8b9548073c5b8572e8b5aa37e931261202084fd7c6906a7be"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
