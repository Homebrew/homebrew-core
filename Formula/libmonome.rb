class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.3.tar.gz"
  sha256 "018e8bf64fda20c09a6de57fee484d7327d9176df27a81b015fa9da4853d8b5d"
  license "ISC"
  head "https://github.com/monome/libmonome.git"

  bottle do
    cellar :any
    sha256 "c80ff6b83563bd1ea8f6d03b79b6f152713aaa5c8f82d94c1616aa1fe31dcdb0" => :big_sur
    sha256 "2313a8a8da4ce4df49333c64fb727c685d3d3f069d496f95a8a27936b716cca5" => :arm64_big_sur
    sha256 "b9be8943cd4758aec068ac75cb966a88e2119063873f7c29913936cc775fba13" => :catalina
    sha256 "44eed89ac8eeec932fde1b7baaf7059c0bd0030ac84be0a6f7695de91954ef5c" => :mojave
    sha256 "95892a3038d8ec5b1ff36438f02165d200a0a1d548af060d1197ae57e3a73e89" => :high_sierra
  end

  depends_on "liblo"

  def install
    # Fix build on Mojave
    # https://github.com/monome/libmonome/issues/62
    inreplace "wscript", /conf.env.append_unique.*-mmacosx-version-min=10.5.*/,
                         "pass"

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
