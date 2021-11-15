class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.10/axel-2.17.10.tar.xz"
  sha256 "46eb4f10a11c4e50320ae6a034ef03ffe59dc11c3c6542a9867a3e4dc0c4b44e"
  license "GPL-2.0-or-later"
  head "https://github.com/eribertomota/axel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "79fd0691a6cc82c1b9cb54a016532154890a8f491c0aedc1bae7f241d73d3680"
    sha256 cellar: :any, arm64_big_sur:  "43a36bca363fd2a2700dbaca686de5d92793ae79b1813e26e6ba1965e9d0acc7"
    sha256 cellar: :any, monterey:       "27626cb6a5926e25177e6e2e0f7751e322e1fd1297c4d46c40216cf6b85a3164"
    sha256 cellar: :any, big_sur:        "94b9f93614705dab7c202df271f9bb1bcd30b4e1170f4ab4b160378e8e5c3a2f"
    sha256 cellar: :any, catalina:       "32832dd93a31589c7f98e510a2edc54e918ee6bab8eab18f4f4a1b953030f3f1"
    sha256 cellar: :any, mojave:         "2df5f78ceaccbdede61b29a191c514a5b86dfb3ab1fd5057506377299d9f8c65"
    sha256               x86_64_linux:   "62718ba4c83d09d0c5b04150c9684aace1e805601b8f58da5b13db32123d8910"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
