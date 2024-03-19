class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/refs/tags/v6.1.8.tar.gz"
  sha256 "e827f640b55fe47a6127dd0c276e76b597e3cb83916be37351cdd6a81d75311e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2cdb7492380690aecf0e7cbbb5b25f0e0ae75ba97d8c8faafafafc7ce95b4ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a84ad65d11dd14e60ee2c8edaed0b2e72d361962282a2ab6d1cfde6a3262c2ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209d70fda58e9b2610d0c8feb9e04c7359f28850e76050b53c179b4ea15c24ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9c48eb3d2043d04a82638cf91205e99dbcc197f3163640bbc0c03d93cd7cb65"
    sha256 cellar: :any_skip_relocation, sonoma:         "35fcf41c949027cd34be5db929d944ed0a9c623fd79cc7d296e32eb2d0bbdc1b"
    sha256 cellar: :any_skip_relocation, ventura:        "f381950c7974cfa9384ccb2800f883c73df3cb435c551d3b8469010c04d66c06"
    sha256 cellar: :any_skip_relocation, monterey:       "f87bff4db1b3732b9603af15c560cb0e386e5f2ac02ece28e71d941fab7b08aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2551a0ae491d1d4f51d72ed804898faf5bacfd9e7db57cf6fd1452c1202275bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f175c9bcdeec3a3974cfb53c4324d1d9dd8dc6b0825182875773e2f6cea94d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
