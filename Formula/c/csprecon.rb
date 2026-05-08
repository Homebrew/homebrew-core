class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "9e68dc2c52d5190c6c70e84c7b9b0123d9eca60f8cda2587be614b31d6e3bff5"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16471a1ffafcfa28450a4deb51341cf3d1f39a8ea84ab56a10205c81718b808f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16471a1ffafcfa28450a4deb51341cf3d1f39a8ea84ab56a10205c81718b808f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16471a1ffafcfa28450a4deb51341cf3d1f39a8ea84ab56a10205c81718b808f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae62de187f6a650ea1fc6a5c17c17432b78305bb5c3479eb4aff3afef984ef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331b45fd65026af5ef82138c3811551010af89a4e7ddaf77e6e976bc7892f95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2369a16215ade907d0d530672bf4a7256036cc7832871a36c4625463ee5e57a2"
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
