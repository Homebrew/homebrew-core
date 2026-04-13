class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "e52c892d3ae457de5c7461b3e6352464650bdab260adc31236fbd8de998c8dbc"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01907688d402625cf2b7f6b37aee084dd9fc3a3a3f4db761cb5b4b3f86d74280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1af2ec223ab32c855125c442f2aba62c676c0159f37743a2d78b354520424e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8367b7ee8b64c4049e5ef989ab8737ab1cd5376fb7b9d22530c77681c954fbd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "87f81cdafd84d295f86292e46ada059c5de14bc34b1e3d3da170480a5a0730ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d5d8fa0a4522097f3266b4c8127611f5ca771f0209e670fc16eb29ca5f0740f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d6ac68dbeaf6b1bd0703f06eb9c48243e87ce3d608fd3e83c3302f743f8dff"
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
