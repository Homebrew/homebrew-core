class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.4.tar.gz"
  sha256 "466acc432b023e6c0bfa8dfb46d79abb1fb8c870f16279ffca7cf5286a63a823"
  license "ISC"
  head "https://github.com/monome/libmonome.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "415d02f115ed624be7e04e5f71dc56b57b313b8c0b35090fc8f73da367f8f5f9"
    sha256 cellar: :any, arm64_big_sur:  "745e10cf5a29c44c9837fa7b822407eca0993ea00c414d99b7ad2a98fe7f059c"
    sha256 cellar: :any, monterey:       "9ee2066771e830a82840baea3bbeb7001195592a1d98c5dac3878e9674d200d5"
    sha256 cellar: :any, big_sur:        "ba70b11a69fab981f80172fcdf8cd78cb88b64386f0d86cfcdf0089d54916dbe"
    sha256 cellar: :any, catalina:       "7aacc1a7d070958460b380f182ccdb7cc073ccef592eb018a69d61d30c07e0f6"
    sha256 cellar: :any, mojave:         "a75784a9297378f3c477ee251f9e729f3e98230113908af03078a92cd4c7d076"
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
