class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.2.tar.gz"
  sha256 "d8f87fc8240214c2ca433f4b185eb3ddbace2065f95487e5d9ac0ab60220393d"
  head "https://github.com/monome/libmonome.git"

  bottle do
    sha256 "c342cf6cf6bf7a216135950836a2e447212d1fd8c05338a63e14325fddd4a820" => :high_sierra
    sha256 "b6ef0089684a846cc18a6405260f7f9426affb7f025dd871a8d7d55627538435" => :sierra
    sha256 "410e76c1cc6ef3791e7efea3e30381cfef6f9df874385ad0c8508856286170bb" => :el_capitan
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
