class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0.tar.xz"
  sha256 "0b266adcfef8c11eed690187e71494baea539efbd632fe221181063ba09508df"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "775f6a757aa829e874edb00b184a6c8cff028506f971d5b220b36194feb0c6eb" => :catalina
    sha256 "3a5ccc4400712b8b3ceeb47ac563cc1fa3fa7b4bb60937d3c1d3218cf51f2e4a" => :mojave
    sha256 "7e7f9960b5594da1e110c16613c9271e428d035ca468c3ae48ec4231b45aa2f1" => :high_sierra
    sha256 "a92418e262ea3ca50d92e5677dd2755207d936a31c8042041955235a2907298d" => :sierra
  end

  conflicts_with "john-jumbo", :because => "both install the same binaries"

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
