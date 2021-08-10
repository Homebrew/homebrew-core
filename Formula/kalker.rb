class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v1.0.0.tar.gz"
  sha256 "3dad381c20fb0ee8c03f0e3e888c4a937123df3cb948f488c057eccd9b352419"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "79ad383108f3c073108c0a0defeba5375e2d59746d5db274fa97db60f587a824"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c8b07d6feabc9d8d4a813b11999de0bda08e5470140479d0b29eb4506777787"
    sha256 cellar: :any_skip_relocation, catalina:      "6046b0d6fe943a55fcf34e0ee1aaccb93242df68a463d384656ba39297517e77"
    sha256 cellar: :any_skip_relocation, mojave:        "0009cbb40dac094063773bdef5f0fedba5b7f633629d1a9b76b5023b6b3eed92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f28ab7f6be9b53c2794c38bb800ca1ac692b71a504f17c56ec87a4bda46a640"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(1, 3, 2n+1)'").chomp, "15"
  end
end
