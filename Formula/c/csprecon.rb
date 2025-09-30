class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "06eb4d1d3d8ef45208d4456293372a76da81c588b096259dc6d020e344ea1d62"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce6b1c59b47c34da20e4546ede658863ec1ffded920eb68a8e5e3cf37f5157be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43e7dada39bc18de317debf6aa89be1517b02261acf152246c15246b41689636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43e7dada39bc18de317debf6aa89be1517b02261acf152246c15246b41689636"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43e7dada39bc18de317debf6aa89be1517b02261acf152246c15246b41689636"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e4746812e45f4e7ab0f0e52818334f44625f988191bac3fb1a6cc4bd6eddfbb"
    sha256 cellar: :any_skip_relocation, ventura:       "7e4746812e45f4e7ab0f0e52818334f44625f988191bac3fb1a6cc4bd6eddfbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449e647160d4771d0aec91ce737cf06ddfb12ed771d2a4879f3ce5ca5b67d185"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
