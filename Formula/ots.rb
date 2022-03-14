class Ots < Formula
  desc "🔐 Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https://ots.sniptt.com"
  url "https://github.com/sniptt-official/ots/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "77101725c2f88a67ec6e4a076c232826c4af265cf0c1348c388ccedcbc4c6492"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e57605b2337da9587cb142466c338db6f0bd9805857bb5722d1a48bbe51a7433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf2a5321f6c45a4c883c2667479ef8950b271276b3b0c9936d0d0f93ecfd4035"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d3400287c3bf19d456a05dd1333410299a830af3d26af822aed0dc6aa50df9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a26787dfccc678b5bd76263e6ab49ef9dc48ad0637e2fba9c95e7c6f5371fc8e"
    sha256 cellar: :any_skip_relocation, catalina:       "2a696ca741d8de5712dac1b06bfc6199cf2e1abf686866f6880d6c91f1d8f047"
    sha256 cellar: :any_skip_relocation, mojave:         "52bce111d1c7726ef06be50301838bf6926397d99fc39ac69d0242c32d972821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ab87ee0c5b202bc18eb3fff61c040816181206c0d57128a14688801754d5c97"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sniptt-official/ots/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}/ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end
