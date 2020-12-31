class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.9.0.tar.gz"
  sha256 "311f6e675e6f7ca488a71022b62edbbc16946f907d7e1695f3f96747ece2051f"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7af20bfa1f4614c84b01163942ccd0dd2e774838a02fdb4908fb6434e4179bc3" => :big_sur
    sha256 "173b2e9e8e9f602ebecf42bd4cf2e2f1420c753897d1f956d134bfa048fd3dd8" => :arm64_big_sur
    sha256 "db8025c76fa5f9fa13d7bc5b9effe7196fa42b998cae164e24855d4c94e799d8" => :catalina
    sha256 "33b860614ff94ce6c69962ecce17bb14fb107c2164f863d0d4c0340759498de3" => :mojave
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "libffi"

  uses_from_macos "ruby", since: :sierra

  def install
    system "make", "build", "PREFIX=#{libexec}", "FEATURES=libinko/libffi-system"
    system "make", "install", "PREFIX=#{libexec}"
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
