class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/eribertomota/axel"
  url "https://github.com/eribertomota/axel/archive/2.11.tar.gz"
  sha256 "7e528df719bad8041346a371290efd8d67959e935f6763ac977ba278d39f5a15"
  head "https://github.com/eribertomota/axel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bf1bfc2e77a9e08c629fca2519166ba6edef07940c466fd95fafb828bd5f1b4" => :el_capitan
    sha256 "1a00cb5af07025ba54e1fb48dea4e0723dcd81142aca8e74caafa79f8ea51dfd" => :yosemite
    sha256 "b0a7bcbab57df1b9877ac3a6a8343a3a5b4256b4cfa5a6bfe777b9ba92930d31" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert File.exist?("axel.tar.gz")
  end
end
