class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "94326828c6f2a2138e2c6ff2e573c4a146f8d08a7fc3aeaa5982d0fea67c7102"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5307850716ebb82bb2b559836c527a8b6d246c61ff08785b9b92d4bfad661124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f70c9999b0a9bb156e5771982a390a48eebdd6ef72da823095b270d0d8dbe6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "106c635aacb53411073354596f41a0267902ff24225a7642dd3758289b39bac8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74d94a7b29587650e3796f970bbec75968997a1f31e452aa101280ba2ec3ffd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f49d986fd3f888c5ffeae03dff56a9306746f2b21e9db1650c4ec9cf60709ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba5b81a1297da025cc17d54540aacc747c660e040a41be84d9c069ca7e9e1e3"
    sha256 cellar: :any_skip_relocation, monterey:       "902c808c45f12b51ec4b3e99e4c02f2df75a9f679cec3ddf7d9b87203c70fe87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "325903681c87861c0f9d5603aa8bf6c0daa043bd130dc2420e11058aea3c59d5"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
