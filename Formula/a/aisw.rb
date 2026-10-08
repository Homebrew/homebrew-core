class Aisw < Formula
  desc "AI and coding agent account manager and account switcher"
  homepage "https://aiswitcher.dev/"
  url "https://github.com/burakdede/aisw/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "80e0546fc890de5660772e99cb0668cbd33797d51d508c0f32f3ae1335db32e6"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aisw --version")
  end
end
