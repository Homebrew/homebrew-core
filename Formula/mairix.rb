class Mairix < Formula
  desc "Email index and search tool"
  homepage "http://www.rpcurnow.force9.co.uk/mairix/"
  url "https://downloads.sourceforge.net/project/mairix/mairix/0.24/mairix-0.24.tar.gz"
  sha256 "a0702e079c768b6fbe25687ebcbabe7965eb493d269a105998c7c1c2caef4a57"
  license "GPL-2.0"
  head "https://github.com/rc0/mairix.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/mairix[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "26221ca2d6ce638ad3f47a597a4b67654ecaaa335f54577b380404951733113e" => :big_sur
    sha256 "b47d8c878e9315d316c48f8bde023532b8704785cde690f6d1c69e2b92a26787" => :arm64_big_sur
    sha256 "3c74d81ccb04da6f3fa9f0f734861738f6dcc924bde12dc8055fd73ea1be68ce" => :catalina
    sha256 "483128f4a24cbf40c26ceef2a9951c44992c57f114327671883b8ab7b9da8569" => :mojave
    sha256 "5975d9e5b741611279f008a50febebfa9d91c4e3e8448c4d8eda80cbd5c371af" => :high_sierra
    sha256 "9cfafed3ea8980b65d1fa5910db71468b3dfd5b81b598d20ff1bf317c55edbca" => :sierra
    sha256 "207bd087f9675c188a430ead82700870c9d3088597a788c334d020d92148caa8" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/mairix", "--version"
  end
end
