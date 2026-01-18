class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0.tar.xz"
  sha256 "0b266adcfef8c11eed690187e71494baea539efbd632fe221181063ba09508df"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?john[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "de355d8210ec0ecde0806a9934c6f14600943b18ae9e98b67571e7b1f7f215f1"
    sha256 arm64_sequoia: "838f0767e0ffb76971a2a0c05c76edb7c0bcd457446ac25eb6b6ac003668197e"
    sha256 arm64_sonoma:  "01e64e35c816560c4a058c4686fa08b821dee81418b56560ab8afdb42d83a567"
    sha256 arm64_ventura: "08bdd817308d691493a5766687aef952d5f2310bed7342b0f8f9a6de10d9a73d"
    sha256 sonoma:        "5bcb36b0fe61d6b2b432944ce913e6f04230ea487b857d931555cba2ab6d37f1"
    sha256 ventura:       "452c5df9c3715d40aa5297a1b3b07f53eb03cff46601f4293904a9d07335d473"
    sha256 arm64_linux:   "24e50afd7e32fae180e8cc88443bb9fbf2328f39e427e7f3999cba7a8cd8d085"
    sha256 x86_64_linux:  "5eed6eadc7ebee51813a7909faf2d436c7c66291f20e0ef1880936faa8b03269"
  end

  uses_from_macos "libxcrypt"

  conflicts_with "john-jumbo", because: "both install the same binaries"

  # Backport of official patch from jumbo fork (https://www.openwall.com/lists/john-users/2016/01/04/1)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/john/1.9.0.patch"
    sha256 "3137169c7f3c25bf58a4f4db46ddf250e49737fc2816a72264dfe87a7f89b6a1"
  end

  def install
    inreplace "src/params.h" do |s|
      s.gsub!(/#define JOHN_SYSTEMWIDE[[:space:]]*0/, "#define JOHN_SYSTEMWIDE 1")
      s.gsub!(/#define JOHN_SYSTEMWIDE_EXEC.*/, "#define JOHN_SYSTEMWIDE_EXEC \"#{pkgshare}\"")
      s.gsub!(/#define JOHN_SYSTEMWIDE_HOME.*/, "#define JOHN_SYSTEMWIDE_HOME \"#{pkgshare}\"")
    end

    ENV.deparallelize

    target = if OS.mac?
      "macosx-x86-64"
    else
      "linux-x86-64"
    end

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", target

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    %w[john unafs unique unshadow].each do |b|
      bin.install "run/#{b}"
    end
    pkgshare.install Dir["run/*"]
  end

  test do
    (testpath/"passwd").write <<~EOS
      root:$1$brew$dOoH2.7QsPufgT8T.pihw/:0:0:System Administrator:/var/root:/bin/sh
    EOS
    system bin/"john", "--wordlist=#{pkgshare}/password.lst", "passwd"
    assert_match(/snoopy/, shell_output("#{bin}/john --show passwd"))
  end
end
