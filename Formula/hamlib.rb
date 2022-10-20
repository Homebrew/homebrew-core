class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-4.4.tar.gz"
  sha256 "8bf0107b071f52f08587f38e2dee8a7848de1343435b326f8f66d95e1f8a2487"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ca4a1a40238e72a834336c9f19a52a7a4ecaae4224e9d39352597555f4c948d8"
    sha256 cellar: :any,                 arm64_big_sur:  "ace0fd60e8dfae3cdd4f807bd49944cd0d28003cfc16d8cf0e751db77fbde4db"
    sha256 cellar: :any,                 monterey:       "5b32a7108366f79102ca69dabafd9ed6f556fba03208235b62f04ccc98508a65"
    sha256 cellar: :any,                 big_sur:        "a56d67cf6837bbe2c57dbb404275ad39ca6c8515a0325f5c4b62323c1ab3a609"
    sha256 cellar: :any,                 catalina:       "b7fe12d40e52c85b463fe66099b11938619126273a23d6b2496f8abb532de244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8665360f495d72e0bd280e0d42d3a91eaa225762e691753194cbcf3fefa314b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
