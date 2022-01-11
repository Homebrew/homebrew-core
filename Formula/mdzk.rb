class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk.app/"
  url "https://github.com/mdzk-rs/mdzk/archive/0.5.0.tar.gz"
  sha256 "f8b72c70cee068896a7786fdffc4c7900085aa2f1f53e973759b829183c9a8e2"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae803ef0541eb3f295aad2ec48172962c9f8e4a6b8d25777334eb24f74e4cb35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4f414bbb57c800dbed55711594558e7502ec7d1e540b104196572496d0773ea"
    sha256 cellar: :any_skip_relocation, monterey:       "b069c104ec9b8525b8119aad475a7715397626b0c117a26c554de33c596361f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "430e188c14494e3800db946b76bad5cd1def8405daaf1a366043cd9a943f2b2e"
    sha256 cellar: :any_skip_relocation, catalina:       "2b9e738df0e6fe3340dc12d4c54c7d21299e86cd26d52d3742d74497439eeb2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65451c0fc85ad37d60bae8033239f21cafbade69240092f689a76acd5cb688e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
