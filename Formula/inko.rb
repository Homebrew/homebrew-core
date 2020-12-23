class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.9.0.tar.gz"
  sha256 "311f6e675e6f7ca488a71022b62edbbc16946f907d7e1695f3f96747ece2051f"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    cellar :any
    sha256 "a32d7804901931240ed8013c30dde09b24c56a25d0b6f2fd49a5ed5efa37a0fc" => :big_sur
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
