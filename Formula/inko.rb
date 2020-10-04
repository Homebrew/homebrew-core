class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.8.1.tar.gz"
  sha256 "02201fd6203d45e0920c849b91aae0adc459d654a27fb3405d181da275365ef5"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a31ee4cbff6f48c5384c1966aa6d3821358706ec4716c9ec5a0f3962adc8be60" => :catalina
    sha256 "bd7f421a086636e9edb9a6946961c717147b174125f45421d6e1db00c09d42dc" => :mojave
    sha256 "49de93ab54879a2a48bc4e3dce4f2bc52a5912085583de9290895eadae4b119e" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "make" => :build
  depends_on "rust" => :build
  depends_on "libffi"

  uses_from_macos "ruby", since: :sierra

  def install
    make = Formula["make"].opt_bin/"gmake"
    system make, "build", "PREFIX=#{libexec}", "FEATURES=libinko/libffi-system"
    system make, "install", "PREFIX=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::stdout

      stdout.print('Hello, world!')
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end
