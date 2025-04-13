class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "a6ccf096301a37d2bbb14fdacfc8c801a8b058b0fd38929639d03c4868564adf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f75ce981113d7d6b63574b888ae22023185635dfb5968643fc2b43fca91fea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0ee506655ff64b7b980067d810d059f9c9be9edf6092a3d74bb234e4212e92b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec9f56867f6ee6c7e6ad1db5fb877dbbad8c54be4aca84a8a94aa358761eea71"
    sha256 cellar: :any_skip_relocation, sonoma:        "c091228e608726810a31e9e7e338e7d852c4e0a275218e78bcda94c711a81cf2"
    sha256 cellar: :any_skip_relocation, ventura:       "f131822bae272a41dc67c5b38459e6dd839858c75002d5f9971753d177c9044e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14aee6e73447828a17a0353fadf9d1d76dcda870509ff84119ba33cd62e05a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4750ee527662c50e8d604af19a2db3d29c35f5ba40323fa8cbc6755abb7ccdc"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "= 15"
    assert_match version.to_s, shell_output("#{bin}/kalker -h")
  end
end
