class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "c95e005e609c9a2d469e79a0dcc4f04960fe35bf851bd0aa75bc329f724fe483"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d47a088a1927db94fa165f249f77b6b2cdbe2315044911c5d0f92ce9954586be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b59ea52bee942655b2dbea34df2fea7e25599e44c03e2ae44cd5291ff045e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa67108c284f0b1821c5c3d0a74f583b0681856a1914474e49a42bee603953a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "566b3e119c4fedfe02f1e4df77f0fa50526e0c89d08cdd8ef6200f091021f7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1769bbc2efb4b636fc3afd84ce3468c95bc891d834438ef5a4224cad19326eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60674e013d27dad2fbf9dd616413dd75fbc3c83de0bc8caa0e2ee713a9641381"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output("#{bin}/overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
