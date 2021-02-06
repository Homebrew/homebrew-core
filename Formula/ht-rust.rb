class HtRust < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/ht"
  url "https://github.com/ducaale/ht/archive/v0.4.0.tar.gz"
  sha256 "5c7e6ff620b3206b395b9b839950dd5ccd62820855eb6b1e4d401ac32b42aa4e"
  license "MIT"
  head "https://github.com/ducaale/ht.git"

  depends_on "rust" => :build

  conflicts_with "ht", because: "both install `ht` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/ht -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
