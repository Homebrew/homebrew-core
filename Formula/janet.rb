class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.21.2.tar.gz"
  sha256 "52db8d18f93351256d0731810e8bea95516db8142f51eeb31664f7884bf63088"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "756d0c33d68296a0a17363566f4345b85f2a453707ef16003999e4592f543a03"
    sha256 cellar: :any,                 arm64_big_sur:  "bc8811c180b4222f674ccc93fd148a6ca1ec780e3f21f87348bcacf918904dc7"
    sha256 cellar: :any,                 monterey:       "c701cf5a35af5745d3f12f73cfb205c25d872788157b1938c3c546c545ce9eb9"
    sha256 cellar: :any,                 big_sur:        "5c9f8c0343377bfb9c14c9bb77e1964e1c2284bc38822094e3f800050af96d84"
    sha256 cellar: :any,                 catalina:       "2b18384af1182096801def0605e95a9d19133a584695f8cb779a8d39c8b335af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7045be668d2766cbd78d5017d72ad55dba3c54fe84857ded8b2eb1b8b20ec361"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
