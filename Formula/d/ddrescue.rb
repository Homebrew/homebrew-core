class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.28.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.28.tar.lz"
  sha256 "6626c07a7ca1cc1d03cad0958522c5279b156222d32c342e81117cfefaeb10c1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "418bae4890b661d379f4e813cfe45e7b903ce4719ce3fb3b86c1d3aa3b5ae84c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66bc1164eadaa4c7c96e26c87aaa8fdf2a2e9b22cae76895f79c65000bbf6fb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "677aa1abaed0f26eab73b60d098e20c32aa8dd653c8d75ec94415f35544f158c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9108e368d2922faeaf63696575756fd87a4b8f63a135699c165945f3b9408c41"
    sha256 cellar: :any_skip_relocation, sonoma:         "24645508dc58415a562fa9aa72484241515e506376acf6ace8d462dee32f150a"
    sha256 cellar: :any_skip_relocation, ventura:        "46a5a2d6dfb1ff7ce67eaf565246c25c6c72cfda699f1aa7c9764618e9eeab88"
    sha256 cellar: :any_skip_relocation, monterey:       "3602fabe3df19327b7fbd5dbe917d291703c9cc356f44970bb758d144692436f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9dff8d471979a163e9d9fe265a46559147694a5914aff1441e7b88ff8d2b7f0"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
