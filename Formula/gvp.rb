class Gvp < Formula
  desc "Go versioning packager"
  homepage "https://github.com/pote/gvp"
  url "https://github.com/pote/gvp/archive/v0.3.0.tar.gz"
  sha256 "e1fccefa76495293350d47d197352a63cae6a014d8d28ebdedb785d4304ee338"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ac60db3ccf491e68595a4ae2185ea2acb1e733bbdd4dabe24617e7f19409790" => :catalina
    sha256 "dce646d2b2bbc9cfecbeb99360b0df2d1149b758a40af3ab81138b544a6e3871" => :mojave
    sha256 "c62a176dc8bee30dcd1453a8b3c608dcd059dc133167df74802d515931470f6d" => :high_sierra
    sha256 "2405a1e481ebfafcd4fbfdc2874feacc402b851fafdc69596d1afa120924c157" => :sierra
    sha256 "ddd00ded9d21c3ecfe23e807619d3ab1b3011bc586db0d7d4aa8d5d87e3689c6" => :el_capitan
    sha256 "5e63da6d9c8d065277491db1658fee5c53089f7dd1bf1180e5d9e7172b376cde" => :yosemite
    sha256 "afbe7d649883c750c182976a7c09035fe30f4d56b1b5859c8d214c01334874f7" => :mavericks
  end

  # Upstream fix for "syntax error near unexpected token `;'"
  patch do
    url "https://github.com/pote/gvp/commit/11c4cefd.patch?full_index=1"
    sha256 "19c59c5185d351e05d0b3fbe6a4dba3960c34a804d67fe320e3189271374c494"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gvp", "in"
    assert File.directory? ".godeps/src"
  end
end
