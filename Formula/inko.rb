class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.9.0.tar.gz"
  sha256 "311f6e675e6f7ca488a71022b62edbbc16946f907d7e1695f3f96747ece2051f"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "43926844caecb8ef58e68dbe731136c148bae98f4895fb1a0f749a2e0393a13a"
    sha256 cellar: :any,                 big_sur:       "0541ff8865a88d0b293ed4a088245c9da57fb4535be08cdb141404bff07cacae"
    sha256 cellar: :any,                 catalina:      "fe5852c91f891f3866d009793086ca265155b76874c9623cf233b5927962b667"
    sha256 cellar: :any,                 mojave:        "6412cea3a6d18324476c2d3b2020f87e86959944048bd423c73fb1f46a959647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75166f6f36d45da8e6b63908442b61e1065d623aec7303e36364da0e453b691d"
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
