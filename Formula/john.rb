class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0.tar.xz"
  sha256 "0b266adcfef8c11eed690187e71494baea539efbd632fe221181063ba09508df"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?john[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "eb3f2d751c1721126e5c5e578ab5863d88ac5fce9f7c5633b123d000acca61d9"
    sha256 arm64_big_sur:  "f1f00939ed4d4fcabc3b210e44187c526dca2be9f7ee9b565ea6140eb193b14f"
    sha256 monterey:       "acc402354e39d5bfb59c7e354dbe411cf93ea39ce7e2db26f422b3d4b0d2ec93"
    sha256 big_sur:        "30a16098075a63a195abd36e2c55c83e5d0bce98476230436bc7a4590b6a523b"
    sha256 catalina:       "bc61b94c66cd5e711cfb069f2f7dc8f448d717cd1179cbe2fed954f0786a0023"
    sha256 mojave:         "6bc29b809b272d370240703ab20715a7e57c651cdcf27b918a49cc9232c386eb"
    sha256 high_sierra:    "96fad56c615dad3f07b2c4babf9e03a0dce6533e3e4cc11e7c37e99ef9379253"
    sha256 x86_64_linux:   "bdb9812c37929c373227f39150582a83711b083483631bad0fd1896b03b41c44"
  end

  conflicts_with "john-jumbo", because: "both install the same binaries"

  # Backport of official patch from jumbo fork (https://www.openwall.com/lists/john-users/2016/01/04/1)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cd039571f9a3e9ecabbe68bdfb443e3abaae6270/john/1.9.0.patch"
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
    system "john", "--wordlist=#{pkgshare}/password.lst", "passwd"
    assert_match(/snoopy/, shell_output("john --show passwd"))
  end
end
