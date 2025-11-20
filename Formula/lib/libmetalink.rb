class Libmetalink < Formula
  desc "C library to parse Metalink XML files"
  homepage "https://launchpad.net/libmetalink/"
  url "https://launchpad.net/libmetalink/trunk/libmetalink-0.1.3/+download/libmetalink-0.1.3.tar.xz"
  sha256 "86312620c5b64c694b91f9cc355eabbd358fa92195b3e99517504076bf9fe33a"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{<div class="version">\s*Latest version is libmetalink[._-]v?(\d+(?:\.\d+)+)\s*</div>}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "60767e9756e2cc9a6fb4c7057711e320d0d1d204913c107c2f866ddc982fea00"
    sha256 cellar: :any,                 arm64_sequoia:  "4ef91819c19bd453ad990a0cea47a38c4b11f527c6a04e91fbca1743bbe09e78"
    sha256 cellar: :any,                 arm64_sonoma:   "2d96d68b47cb11ebd54431713f613b092ef59e60cbb0ebde4752128035e8a3f5"
    sha256 cellar: :any,                 arm64_ventura:  "1684da3a02e39ed1a65dc154f06f309119cff3010a45efbbeb1d653081885bc8"
    sha256 cellar: :any,                 arm64_monterey: "4181f8a100f736a945001f57c2ad8f768ad99cdad6789a19d9f21e0cfdd4d3fb"
    sha256 cellar: :any,                 arm64_big_sur:  "a5eec14410ca7f2ea831d91c273d6372bc851f930944d207f07f35245b077a91"
    sha256 cellar: :any,                 sonoma:         "0d1573fb4f98d9fe1131e0f13e73df5b69c346a740a41b3efc5972cc62763eb4"
    sha256 cellar: :any,                 ventura:        "458a2aed06056d0cc3dd1005f93210c9c686ba2515d8550ec0fd6f8348168da6"
    sha256 cellar: :any,                 monterey:       "c1a510079e53edc2ebd437321751752e897c253332dc6644ebc6b03cecbf48f2"
    sha256 cellar: :any,                 big_sur:        "ec4a4a8f898432cccfa2198c0e877daf2d80c2ab5bc92a7a9134a3dd75529a87"
    sha256 cellar: :any,                 catalina:       "a18e6199b4d775a32693aa38b80551d547eb1de58c5d7c788f706276ce296d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3fdd87e5927d64ecdf222d1bb8527d43de66446ba24e07f54dfb4c37ebd93183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583e662593473f7310e1c3e3bed77a89a4dc43aed5fd1ce6a12a7260ec69c5f5"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "expat"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
