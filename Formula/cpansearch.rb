class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"

  head "https://github.com/c9s/cpansearch.git"

  bottle do
    cellar :any
    sha256 "7806b7b02a7bd6e578a7cbfc41935e854ec91c1174722bcbcd45f2716be31174" => :sierra
    sha256 "f68927e2f114cb09d4c5f7057097f4685139dc16a58306b572b011dc11e5b27e" => :el_capitan
    sha256 "554213c4d54b3bebfabf4eb10d274a9f86ba6271607b464a74541593cf52b8ac" => :yosemite
    sha256 "02c985ade39c5df0aa2885022d8a1c56238975a147bda39adb0394c8acbde27a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "make"
    bin.install "cpans"
  end

  def caveats; <<-EOS.undent
    For usage instructions:
        more #{opt_prefix}/README.md
    EOS
  end
end
