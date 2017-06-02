class Minicom < Formula
  desc "Menu-driven communications program"
  homepage "https://alioth.debian.org/projects/minicom/"
  url "https://alioth.debian.org/frs/download.php/file/4215/minicom-2.7.1.tar.gz"
  sha256 "532f836b7a677eb0cb1dca8d70302b73729c3d30df26d58368d712e5cca041f1"

  bottle do
    sha256 "63584b5ee8463dfb6cef69ad32308c51a4e83778dd44b80fc4c1e7c40cb48b2e" => :sierra
    sha256 "820aae10f1c298350f51f7571d4d6becb4b0cfc876fb77126ea1e43bec8466e4" => :el_capitan
    sha256 "5f17b6f15c2417acbda3a91b64f7df166b29fd2389adc52f011e2541f1fdbcb9" => :yosemite
  end

  def install
    # There is a silly bug in the Makefile where it forgets to link to iconv. Workaround below.
    ENV["LIBS"] = "-liconv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (prefix/"etc").mkdir
    (prefix/"var").mkdir
    (prefix/"etc/minirc.dfl").write "pu lock #{prefix}/var\npu escape-key Escape (Meta)\n"
  end

  def caveats; <<-EOS.undent
    Terminal Compatibility
    ======================
    If minicom doesn't see the LANG variable, it will try to fallback to
    make the layout more compatible, but uglier. Certain unsupported
    encodings will completely render the UI useless, so if the UI looks
    strange, try setting the following environment variable:

      LANG="en_US.UTF-8"

    Text Input Not Working
    ======================
    Most development boards require Serial port setup -> Hardware Flow
    Control to be set to "No" to input text.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minicom -v", 1)
  end
end
