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
    sha256 "bc61b94c66cd5e711cfb069f2f7dc8f448d717cd1179cbe2fed954f0786a0023" => :catalina
    sha256 "6bc29b809b272d370240703ab20715a7e57c651cdcf27b918a49cc9232c386eb" => :mojave
    sha256 "96fad56c615dad3f07b2c4babf9e03a0dce6533e3e4cc11e7c37e99ef9379253" => :high_sierra
  end

  conflicts_with "john-jumbo", because: "both install the same binaries"

  # Backport of official patch from jumbo fork (https://www.openwall.com/lists/john-users/2016/01/04/1)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cd039571f9a3e9ecabbe68bdfb443e3abaae6270/john/1.9.0.patch"
    sha256 "3137169c7f3c25bf58a4f4db46ddf250e49737fc2816a72264dfe87a7f89b6a1"
  end

  def install
    inreplace "src/params.h" do |s|
      s.gsub! /#define JOHN_SYSTEMWIDE[[:space:]]*0/, "#define JOHN_SYSTEMWIDE 1"
      s.gsub! /#define JOHN_SYSTEMWIDE_EXEC.*/, "#define JOHN_SYSTEMWIDE_EXEC \"#{pkgshare}\""
      s.gsub! /#define JOHN_SYSTEMWIDE_HOME.*/, "#define JOHN_SYSTEMWIDE_HOME \"#{pkgshare}\""
    end

    ENV.deparallelize

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", "macosx-x86-64"

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
    assert_match /snoopy/, shell_output("john --show passwd")
  end
end
