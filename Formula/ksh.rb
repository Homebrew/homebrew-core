class Ksh < Formula
  desc "KornShell, ksh93"
  homepage "http://www.kornshell.com"
  url "https://github.com/att/ast/releases/download/2020.0.0/ksh-2020.0.0.tar.gz"
  sha256 "8701c27211b0043ddd485e35f2ba7f4075fc8fc2818d0545e38b1dda4288b6f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea7be886a6acee55713ca673ce1578a1303389fb2a964734c38137d3610d7f2b" => :catalina
    sha256 "3bc3469d43fba904b3045722d43bb52444f88c2e6745af977bae9b52d1f0090e" => :mojave
    sha256 "733e1c6bdd05054bf8d0097a6ae9ea2ca21e74b4676df7b424d4b9f43078afd4" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/ksh -e 'echo Hello World!'").chomp
  end
end
