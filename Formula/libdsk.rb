class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "http://www.seasip.info/Unix/LibDsk/"
  url "http://www.seasip.info/Unix/LibDsk/libdsk-1.4.2.tar.gz"
  sha256 "71eda9d0e33ab580cea1bb507467877d33d887cea6ec042b8d969004db89901a"

  bottle do
    sha256 "3fa32e86ffffbc3754f2834a456ebf9510efa15ff2365c5658247a1948b0e934" => :sierra
    sha256 "8ed498f088ad97d88d267351a8c90f9db54ac2f42e6670e5f4bda2eb20864852" => :el_capitan
    sha256 "3e17fa4773145ca69db2ba8f36165b9a5f041a297a01b17a9692218790a5aa38" => :yosemite
    sha256 "b1406d66e802413b7999190502ee986931f4c91f48c76ac6520506640a1c1dd5" => :mavericks
  end

  def install
    # Avoid lyx dependency
    inreplace "Makefile.in", "SUBDIRS = . include lib tools man doc",
                             "SUBDIRS = . include lib tools man"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
    doc.install Dir["doc/*.{html,pdf,sample,txt}"]
  end

  test do
    assert_equal "#{name} version #{version}\n", shell_output(bin/"dskutil --version")
  end
end
