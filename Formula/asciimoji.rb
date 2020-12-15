class Asciimoji < Formula
  desc "Program to search asciimoji saved in a local, editable file"
  homepage "https://gitlab.com/jjocram/asciimoji"
  url "https://gitlab.com/jjocram/asciimoji/-/archive/1.0.2/asciimoji-1.0.2.tar.gz"
  sha256 "cc1c983f78e2d494d8e9d2bcbdfdb4ab55d93e4ba0cbeebd7c5a46025047fab7"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/asciimoji shrug")
    assert_match "¯\\_(ツ)_/¯", output
  end
end
