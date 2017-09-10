class Libdsk < Formula
  desc "Library for accessing discs and disc image files"
  homepage "http://www.seasip.info/Unix/LibDsk/"
  url "http://www.seasip.info/Unix/LibDsk/libdsk-1.4.2.tar.gz"
  sha256 "71eda9d0e33ab580cea1bb507467877d33d887cea6ec042b8d969004db89901a"

  bottle do
    sha256 "d46bdf8e9c779b22a2a21c123572c08130aa36b8a817365ee3bd76219478aad3" => :sierra
    sha256 "b14fb001603c2ba33a26c0f49c7b008659ca5aa05ffaa01ab8147bac4da40d46" => :el_capitan
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
