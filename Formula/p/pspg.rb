class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.10.tar.gz"
  sha256 "806d6b3c3f53144487368caff851d3373735129db68908b9eb45efa58e3d0a8e"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ec5c28b0978e06d0c542d412a4f1eb79fb2040a66672bf93338797c5242c936"
    sha256 cellar: :any,                 arm64_sonoma:  "7fc9380a961bf527852cf58c8546d39f505b8d1ce4bda5c36e3479a39590e70b"
    sha256 cellar: :any,                 arm64_ventura: "a89432e1926c4e45f4b1a64bd7370e30ba11fa78b4d8a7246aca9b165bd6808f"
    sha256 cellar: :any,                 sonoma:        "945bdfc136146827f10e169cba65fc39e180b462ccb17106b725cb1ac42b7c87"
    sha256 cellar: :any,                 ventura:       "d2006ae2827305e010d4051932c8353d5dc32bbf9bef3ed19947c273ff38aa01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d6c85ee19c8385b69028c9e8c005109e9bc711d5b569c84ca8a2f53d0a18420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78c75c0c87a10124716c03268cafcce4f61ada7f72c13f44d93f4adc550d950c"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
