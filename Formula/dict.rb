class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "https://dict.org/bin/Dict"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.1/dictd-1.13.1.tar.gz"
  sha256 "e4f1a67d16894d8494569d7dc9442c15cc38c011f2b9631c7f1cc62276652a1b"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "bf7cb1eff5364cef0a00a5c711fb42e498a4be1bcb3ebcbde5538b56e956de11"
    sha256 arm64_monterey: "2c04cdc3159fc7e11ab8c221aabc76c5a370c73e0ecbaf26b3c803f313caeaa7"
    sha256 arm64_big_sur:  "d22bd87df2353d4fc9260f3c7a1d0d99c2653e2c7b71f1efcf537c65415b13a0"
    sha256 ventura:        "9d040510785ea9f3d6b989211138348b1db81d5adb02e4c34c1647f0e470865d"
    sha256 monterey:       "0c1a3e0a5f9f2de898f106260c19d212468aefdd5adb3f04df0f26c76ad2e90a"
    sha256 big_sur:        "de7803163887f1533950fdae9bd6c81901946b58339bee9985f55cd312db3afb"
    sha256 x86_64_linux:   "e34a6fd3ec083c27f88d431eea7e3e21be17046a0b8eb3f51ba3f55226853d77"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end

  test do
    assert_match "brewing or making beer.", shell_output("#{bin}/dict brew")
  end
end
