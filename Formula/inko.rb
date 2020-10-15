class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.8.1.tar.gz"
  sha256 "02201fd6203d45e0920c849b91aae0adc459d654a27fb3405d181da275365ef5"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    cellar :any
    sha256 "04de7a0e85ea41b689a758e52466595c8aa80454c9bf6fbfa9325679fdfeb6fd" => :catalina
    sha256 "0ed7a6a90eefbf03348e9e0640f4fbd3869f70b773615df6f758f856950bcf1e" => :mojave
    sha256 "cca1041a8cafaef5061922687416f533b4e740193b2413ae704d34cbef004990" => :high_sierra
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
