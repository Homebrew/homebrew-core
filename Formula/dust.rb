class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.2.tar.gz"
  sha256 "890972fbf1a7f0a336c0f20e1e9ecc756c62d3debd75d22b596af993a3d8af01"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d4abe259d22e9e5ff46e310a74fec0cda4258ad6e6e5919a1e023decda2938"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "228abef678e9fb4b73b6118e492aa0523afc4da25b8da8e9d83f503493ba3d1d"
    sha256 cellar: :any_skip_relocation, monterey:       "eba5754fcc439fa8b14076fd7ecaea670c80c249611e52408879218677cf0dfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "97580a2a5707e9c03dbcbf682d6be99eb57db9c738ccdc3cf2527feabf6ac1a2"
    sha256 cellar: :any_skip_relocation, catalina:       "1608043b5948152efa6a919e73f292ea431653e6af035ee03572932680a7fe3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07c5068f343f6d629a2af6794b0ebeab71e941d5cdd78c996858e3385f4fcda"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
