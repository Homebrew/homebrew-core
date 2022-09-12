class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.10.0.tar.gz"
  sha256 "d38e13532a71290386164246ac8cf7efb884131716dba6553b66a170dd3a2796"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f9dbb9ca91c3c850de16e96b770118a7e98c2275b5d45e2d04e322702266ca4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97fd0e158ca05967044ce52f22efd5226e4f1a03d72dcc74d54759ac63490ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "1abad4e1a95ee97fbaa3ff1cc5c95eeada47e24ed0d9bc1611fe191658368b28"
    sha256 cellar: :any_skip_relocation, big_sur:        "d759b01b4aafb4117a280f6734e74e5df7006104ea1e9bb88377e91f29d69536"
    sha256 cellar: :any_skip_relocation, catalina:       "2637485ed2ad0644e69fcb33cf4c56e9db6f9ab42751b9502e71299843d66c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a0af9b41a880e969480fe9dba4673da888a994e7ddb097c3382a296decdf71"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    system "make", "build", "PREFIX=#{prefix}", "FEATURES=libinko/libffi-system"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::stdout

      stdout.print('Hello, world!')
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end
