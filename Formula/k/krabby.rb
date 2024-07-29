class Krabby < Formula
  desc "Print pokemon sprites in your terminal"
  homepage "https://github.com/yannjor/krabby"
  url "https://github.com/yannjor/krabby/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "346f44b2c38084413da6aeadff5d87f1cc3ab60275653d95921ca6488e3210e3"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "krabby #{version}", shell_output("#{bin}/krabby --version")
  end
end
