class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-2.17.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bibclean-2.17.tar.gz"
  sha256 "d79b191fda9658fa83cb43f638321ae98b4acec5bef23a029ef2fd695639ff24"

  bottle do
    cellar :any_skip_relocation
    sha256 "08446fff8a8c9f0b58238290cab9f14d06131db299df35702fece9804cbfedbe" => :mojave
    sha256 "0716be98bca14351bf4f0ca3da343e6a79bb945a34929eadf7742824342f48ff" => :high_sierra
    sha256 "addcead999d4c3ec3e5112c227512e200681e4775b163bfc24f2bff71ac15f77" => :sierra
    sha256 "1e09e98ec9528bbe6386fc12274bf56fcdc69ddccdef119b0dd3381cebefc8c0" => :el_capitan
    sha256 "6cba0c4e4d59324ed70a64718c6541dddba994c8cc509db1d7914a1e7f584dcb" => :yosemite
    sha256 "8e72af36765c47807c07faec8d56d811e0b2cd2ca511adbefad95fbd65aa72cd" => :mavericks
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in macOS
      # requires that the full path to the target already exist.
      s.gsub! /[$][(]CP.*BIBCLEAN.*bindir.*BIBCLEAN[)]/,
              "mkdir -p $(bindir) && $(CP) $(BIBCLEAN) $(bindir)/$(BIBCLEAN)"
      s.gsub! /[$][(]CP.*bibclean.*mandir.*bibclean.*manext[)]/,
              "mkdir -p $(mandir) && $(CP) bibclean.man $(mandir)/bibclean.$(manext)"

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = $(prefix)/share/man/man1"

      # Place all initialization files in $(prefix)/bibclean/share/ instead of
      # ./bin/ to comply with standard Unix practice.
      s.gsub! /install-ini.*uninstall-ini/,
              "install-ini:  uninstall-ini\n\tmkdir -p #{pkgshare}"
      s.gsub! /[$][(]bindir[)].*bibcleanrc/,
              "#{pkgshare}/.bibcleanrc"
      s.gsub! /[$][(]bindir[)].*bibclean.key/,
              "#{pkgshare}/.bibclean.key"
      s.gsub! /[$][(]bindir[)].*bibclean.isbn/,
              "#{pkgshare}/.bibclean.isbn"
    end

    system "make", "all"
    system "make", "check"
    system "make", "install"

    ENV.prepend_path "PATH", pkgshare
    bin.env_script_all_files(pkgshare, :PATH => ENV["PATH"])
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{small,
      author = {Test, T.},
      title = {Test},
      journal = {Test},
      year = 2014,
      note = {test},
      }
    EOS

    system "#{bin}/bibclean", "test.bib"
  end
end
