class Execline < Formula
  desc "Small, secure scripting language"
  homepage "http://skarnet.org/software/execline/"
  url "http://skarnet.org/software/execline/execline-2.1.5.0.tar.gz"
  sha256 "8a3605a6db73183baa376bf2130e8b7eb75a5b5347c7f9144e520fe86bcb1142"
  head "git://git.skarnet.org/execline"

  bottle do
    cellar :any_skip_relocation
    sha256 "421c3335ccbd38e1e8e27a3f4c9a3971694d0c9ca479f36a53c6f8425870df30" => :el_capitan
    sha256 "c7b4cb3676adcfe8adcf780b6aaf82cf388cf58477614a86cb877967f3c0ebb3" => :yosemite
    sha256 "4958d0974ee0c47d99bbf61466d3244c13a3b0569789039c80760d1ce6c07969" => :mavericks
  end

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
