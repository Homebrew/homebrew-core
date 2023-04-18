class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.10.0.tar.gz"
  sha256 "d38e13532a71290386164246ac8cf7efb884131716dba6553b66a170dd3a2796"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07d8357f8d0d21e359588df7b846f5959c08aa193121bfc7b5f8b905c60acf73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d8f51a76b0c7260dfcf311141cb52921f6b899ec962b521fb75a5b56b94b00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4a2a7c699d3ebffe9f92dc7dff1f839e369028404ce0997f945622a0603115e"
    sha256 cellar: :any_skip_relocation, ventura:        "9fc8e211538f6f0eb4106524307d1007cebb5e4d4530d0f1d0368faa8b8bf138"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1567b9a80ecf61d33dcc09637b76ea2c32be5a1558bbaf5259d0cd085a8f1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0e4889fef0fcf3d9eabc466c7290f38d4fd7b23bb1b422c71b301fcabe19a03"
    sha256 cellar: :any_skip_relocation, catalina:       "4dab624dbe2acb233d0e0f1b92238988de99507e47400df9974b8b4c8c0e5293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "793f34b23c6045b3e56bd64f6be059b4cb0cbc1f24a85cc688e6c41c99cabee1"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    system "make", "build", "PREFIX=#{prefix}", "FEATURES=libffi/system"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end
