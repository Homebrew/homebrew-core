class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.8.0.tar.gz"
  sha256 "b2e69b4ca694afd580c7ce22ab83a207174d2bbc9dabbad020fee4a98a1205be"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2443b91247ef98143863f23724ab1ffe3b192aa65471d2198ab02ffa72936ce9" => :catalina
    sha256 "465474b8dd2b6344efda4d611341a0d40c46965fabce4e3446bb3bc0a45c2392" => :mojave
    sha256 "8805fb02b8cc13ffe9ca11663140f502dfbcbe5a4cbdf1262bd88758bc88167f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
