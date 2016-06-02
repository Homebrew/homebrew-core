class Execline < Formula
  desc "Small, secure scripting language"
  homepage "http://skarnet.org/software/execline/"
  url "http://skarnet.org/software/execline/execline-2.1.5.0.tar.gz"
  sha256 "8a3605a6db73183baa376bf2130e8b7eb75a5b5347c7f9144e520fe86bcb1142"
  head "git://git.skarnet.org/execline"

  depends_on "skalibs"

  def install
    system "./configure",
      "--prefix=#{prefix}",
      "--disable-static",
      "--bindir=#{libexec}",
      "--with-sysdeps=#{Formula["skalibs"].opt_prefix}/lib/skalibs/sysdeps",
      "--with-lib=#{Formula["skalibs"].opt_prefix}/lib",
      "--disable-shared"
    system "make", "install"
    (bin/"execlineb").write_env_script libexec/"execlineb", :PATH => "#{libexec}:$PATH"
  end

  test do
    test_script = testpath/"test.eb"
    test_script.write <<-EOS.undent
     import PATH
     if { [ ! -z ${PATH} ] }
       true
    EOS
    system "#{bin}/execlineb", test_script
  end
end
