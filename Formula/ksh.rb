class Ksh < Formula
  desc "KornShell, ksh93"
  homepage "http://www.kornshell.com"
  url "https://github.com/att/ast/releases/download/2020.0.0/ksh-2020.0.0.tar.gz"
  sha256 "8701c27211b0043ddd485e35f2ba7f4075fc8fc2818d0545e38b1dda4288b6f7"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fa4ca19495438d415fae8d81de8efdb45148f4d7e5733a5a294975f9e889b18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ade0f9307c006c9833a85a4c046019668e327197ebe0220c8ed74fa59958f090"
    sha256 cellar: :any_skip_relocation, monterey:       "100c44e8c7bfad8c63fc3eb8ee2afc9a5c10f33481c71f4283d6720ce78e0ba4"
    sha256 cellar: :any_skip_relocation, big_sur:        "92ca5f26f79c9ca9637331d83b1e1521ab3e1c772d9e2d363c8353fb2c568a61"
    sha256 cellar: :any_skip_relocation, catalina:       "ea7be886a6acee55713ca673ce1578a1303389fb2a964734c38137d3610d7f2b"
    sha256 cellar: :any_skip_relocation, mojave:         "3bc3469d43fba904b3045722d43bb52444f88c2e6745af977bae9b52d1f0090e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "733e1c6bdd05054bf8d0097a6ae9ea2ca21e74b4676df7b424d4b9f43078afd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a6f8d5a96eaf9d91da32c58e453d7aacc4f47acea57f6a2b3db7cc108bbcd1f"
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
