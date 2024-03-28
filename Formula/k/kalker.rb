class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "f7c5ed0f565367965f9aeb5a6b0ca9964b1eefa17a0830b7cda33384d0efa432"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5662f5dcf8c16cc040411b3d31310be2461516f02e9e4ae7c7be7b312623d47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848595a35f2a8abfc748920baf97f7c2235a4504ebffdc47da03b607ccc834d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "824213eadaf36cf7804b7969b5d83eecc907f64cb6679368c2c71f20b2a4d6b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0081eeb8a42f15fe2a95fec6202306602467ddb3be09ee5d7dec6d049c46ee05"
    sha256 cellar: :any_skip_relocation, ventura:        "b716ef722fa64ea5187328c5fc5d2084a87e70db4544bcec11708120f7d8c5c2"
    sha256 cellar: :any_skip_relocation, monterey:       "4c2cf199412bf264ceef40238d8e4f19bac9ba7411c258cc988dbcb231150a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f9f548dcf1cc76318336f48d270b8c44e31379f2f08eb5c216449c8fc19df9"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
