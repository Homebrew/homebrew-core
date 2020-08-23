class Inko < Formula
  desc "The Inko programming language"
  homepage "https://inko-lang.org/"
  url "https://gitlab.com/inko-lang/inko/-/archive/v0.7.0/inko-v0.7.0.tar.gz"
  sha256 "81a613b4d6bee524a8fe8e346466b7f277a42875b357ad61ba0ca3871750c1e3"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a31ee4cbff6f48c5384c1966aa6d3821358706ec4716c9ec5a0f3962adc8be60" => :catalina
    sha256 "bd7f421a086636e9edb9a6946961c717147b174125f45421d6e1db00c09d42dc" => :mojave
    sha256 "49de93ab54879a2a48bc4e3dce4f2bc52a5912085583de9290895eadae4b119e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "make" => :build
  depends_on "rust" => :build

  uses_from_macos "ruby", since: :sierra

  def install
    make = Formula["make"].opt_bin/"gmake"
    system make, "install", "PREFIX=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", INKOC_HOME: libexec/"lib/inko"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::stdout

      stdout.print('Hello, world!')
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end
