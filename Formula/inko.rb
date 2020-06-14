class Inko < Formula
  desc "The Inko programming language"
  homepage "https://inko-lang.org/"
  url "https://gitlab.com/inko-lang/inko/-/archive/v0.6.0/inko-v0.6.0.tar.gz"
  sha256 "3560023128675db5f76698e546e7f3fce70f45816735fb3fa71d103ae383fc61"
  head "https://gitlab.com/inko-lang/inko.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "make" => :build
  depends_on "rust" => :build

  uses_from_macos "ruby", :since => :sierra

  def install
    make = Formula["make"].opt_bin/"gmake"
    system make, "install", "PREFIX=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :INKOC_HOME => libexec/"lib/inko"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::stdout

      stdout.print('Hello, world!')
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end
