class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz"
  sha256 "31e066137a962676e89f69d1b65382de95a7ef7d914b8cb956f41ea72e0f516b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a0af7dcbb5c83f6f3f7ecd507c2d352c1a018f894d51ad241ce8492fa598010f" => :big_sur
    sha256 "5334dd344986e46b2aa4f0471cac7b0914bd7de7cb890a34415771788d03f2ac" => :catalina
    sha256 "22948764d8f8d7be4870ff92dae64d986eb63a9150b219c20fff87d1a6aa93d6" => :mojave
    sha256 "702dc7f78444d2f4f1c19324be654bcbb8b99dd0e9ce26c3e2fbc3b6464a189f" => :x86_64_linux
  end

  conflicts_with "perkeep", because: "both install `hello` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
