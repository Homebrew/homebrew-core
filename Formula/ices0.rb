class Ices0 < Formula
  desc "Source client for broadcasting to Icecast/Shoutcast servers in MP3 format"
  homepage "https://github.com/Moonbase59/ices0"
  url "https://github.com/Moonbase59/ices0/archive/v0.4.11.tar.gz"
  sha256 "9179496149e763a75fea37bf6ec12947cad4bdb868b401d34728b353b836047a"
  head "https://github.com/Moonbase59/ices0.git"

  # building
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  # input/output
  depends_on "faad2"
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libshout"
  depends_on "libvorbis"
  depends_on "libxml2"
  depends_on "mp4v2"

  def install
    system "aclocal"
    system "autoreconf", "-fi"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # For Homebrew/homebrew-core this will need to be a test that verifies
    # the functionality of the software. Run the test with `brew test loudgain`.
    # Options passed to `brew install` such as `--HEAD` also need to be
    # provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    # assert_match /^loudgain\s+#{version}.*/,
    assert_match /^ices\s+0\.4\.11.*/,
      shell_output("#{bin}/ices -V").strip
  end
end
