class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha256 "2cec51efa0c8d65ace8b21eaa08384b77abc5087b46e785f78de1c21fb754cd5"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "97cc58e57eb823ca7be58be09b8f36e5bd431150391ccb50e1d0647205089430"
    sha256 cellar: :any,                 big_sur:       "5d0c028406ba39fe3f26f3994d3454935e5f38f07018b03a953f9aff81999b6a"
    sha256 cellar: :any,                 catalina:      "83f0706e4b12f54145a8fded793efcbde5cf16ca8c53122987f4c22bc5f87fd5"
    sha256 cellar: :any,                 mojave:        "cfaf7b932bb1eba280ae9353377e7069b8e73585bced5aff0fb4cc9e501f7055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d8ce236e89a71233f9ff42e9d6ad46c4ac504f3c6684e1af98d6659f07c59f8"
  end

  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
  end
end
