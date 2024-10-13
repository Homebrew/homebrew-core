class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/refs/tags/v1.24.tar.gz"
  sha256 "08d958c49269e7025a998a617f3d6a0b6dcd7432437f950f0d0e3335bf7b59b3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c83752ade79c7914a786a0deba36b17c8f51c8c34238364e4c190c25d32f6be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dbf3a93ca803663089d7b99842e15ec145101b6a19560a0d33b9fc935e7e74e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b8f00ce64616d9a75c81e533783d118fd60d3e8ca412ae1af57701598efce67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb9acae2a52e836ada9ecccdf9d5d7b35bd590f43af48a2a5845780f785e430b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e23866ef1204163a43b7e78e23d192cda14182f1837c549e30075e8b0f3bdf3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "59643ebb8d82b9285161b6b02fb6d567c9313003e0030db8d3eadc615b7f6633"
    sha256 cellar: :any_skip_relocation, ventura:        "a0851b68b27a6721b76f19ea6ae85f8ffc28c425d6e9e9c269a020431b239139"
    sha256 cellar: :any_skip_relocation, monterey:       "debe8485884c401c707082ece657be86b4a5bbaa737959858dd7cb01936bdb54"
    sha256 cellar: :any_skip_relocation, big_sur:        "af9fa9e620348645b7bc76c65b927c634aa97c78704d85b4c777d9ebe9a748d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da14d26cdab843a7100443af7e2f793a29329af1abb0ed663da8712330ddda5b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"powerline-go"
  end
end
