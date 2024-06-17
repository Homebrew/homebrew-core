class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "fb523ccec493ed6cfc590e0436de6754aea4d2cbf17b64b9df8a5babd095116d"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "accc8df0f9826e3976dead6b1926b03a1a12a83d0af85a033bf0d376ae347f69"
    sha256 arm64_ventura:  "2b2426446ad3147f86711616102f71b59b5256e502b62ec60045b68b5ba6bdae"
    sha256 arm64_monterey: "17e71628c4fd7ab569ec698ea85f326e3f1d42876584a18d9e2762d6f1686141"
    sha256 sonoma:         "08d9971d9f11c4d4a18a3758576d0b055325ae477efa70871a14ebe808a7dd8c"
    sha256 ventura:        "3956e1b698ce66782aad43611219cbbc017627d8dea77cf4289036ebda884251"
    sha256 monterey:       "0b039d3824285ee68578171c268894d22ae1e1fa0952801556744c27524d6fd9"
    sha256 x86_64_linux:   "91860516444f8cfa0f5aac4eb2f1e05fdf2bf1ef8f13d592f6287ee21afb6694"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
