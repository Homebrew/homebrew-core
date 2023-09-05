class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "8b28b7dd572164bf99afba38edd19bb19f2ba778a69ef06eca64426ed1ef5168"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b87335f5c2a6ca5323ced3f2746f3799281e883cd7763cc52004c600722ff35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e850a085ef66554693301002a58fd95949a8a3db7e6d096c4c95927c93cf07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52c5e3e0b1ca1feb1a617e568de35fc8148fc77ec1a4c498ff3b093d8832cc9"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f99b932af819291988affd6ffbca8c2977c3624578a6599cca85a084560326"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc2d68deba15a34ace75ea78dec2a69781ddc14c1842d4a9dc85e6df3172e30"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2bfddb4fc8c7b560ca1b063700f2b04e3096b51ce6392021a234ed8bfc2d6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103eb96d4e2ead0355eb865193fec04eee786b92d79e0f57749d315d5af40c7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
