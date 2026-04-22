class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "f40b405f6bad7483a93b71a8c8fdafa35d50e667e4e0c0ee2fbbb592dcc0a438"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0c5d716a4e2af43b24e7ceb7d1e09b5856a2103d133027a442ffb0fd2104321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a54018ff813415704c08ef18f54122ee747c452539271357dc240e93b118d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63897960385cdd9a991969bbe100e86aacc73cc92b89940d8eb711508aa4054"
    sha256 cellar: :any_skip_relocation, sonoma:        "993e25a290b9569dec9a08e1e7d748867df48f0b3e2493f08cf93ef214147697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f56bb6221802f0b328df276f230a7e176fb749f0f16548441c295f322eec6327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "772aac295ea8c9230302e24433f70097996adaca212ecfe764ce4874345aee2b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
