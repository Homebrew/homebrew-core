class Csmith < Formula
  desc "Generates random C programs conforming to the C99 standard"
  homepage "https://embed.cs.utah.edu/csmith/"
  url "https://embed.cs.utah.edu/csmith/csmith-2.3.0.tar.gz"
  sha256 "f247cc0aede5f8a0746271b40a5092b5b5a2d034e5e8f7a836c879dde3fb65d5"
  head "https://github.com/csmith-project/csmith.git"

  bottle do
    cellar :any
    sha256 "fdce1186c77ea774ed5575cd59bc194ab35725d3117c9a57bd54ce351a620965" => :catalina
    sha256 "7c3759ccefa73b295acd5e7e631c40594f6983e26e903b54a88a9e0dfdfcaa96" => :mojave
    sha256 "e8e818a9898b4145c5622810958fa8616f8b57156f09aeaf3045873210f0856a" => :high_sierra
    sha256 "2e78da57153124cb3feca12955d0bbadbc4e90dbff6c34a08532aea55c75ba8e" => :sierra
    sha256 "472992fd577ec20b025397c840823abf8f88d719e7d86bba427446a38cc5584d" => :el_capitan
    sha256 "277a9e03f3bfdd03f1e3136ef867604c7f6c4f9763346223bb41b47f0fa72f0d" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    mv "#{bin}/compiler_test.in", share
    (include/"csmith-#{version}/runtime").install Dir["runtime/*.h"]
  end

  def caveats; <<~EOS
    It is recommended that you set the environment variable 'CSMITH_PATH' to
      #{include}/csmith-#{version}
  EOS
  end

  test do
    system "#{bin}/csmith", "-o", "test.c"
  end
end
