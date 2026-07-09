class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://hebcal.github.io/"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "7f7c1b54d1a8698219c94738bb3730cdd7e969f9cb6b20116f1a854d90ae5e8e"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "209a4013d8eaa838d014ca0edd41dcd7641c2ecc47009519dab3d6bee8e7c84f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "209a4013d8eaa838d014ca0edd41dcd7641c2ecc47009519dab3d6bee8e7c84f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "209a4013d8eaa838d014ca0edd41dcd7641c2ecc47009519dab3d6bee8e7c84f"
    sha256 cellar: :any_skip_relocation, sonoma:        "54ac453d24dac878dc1455e5f98329994859fbd59173d12d47a3d6230a5dbc5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaacdfe4f2bf2c1864e54cef8ca469e5b2966462148d936da06a7b36ac03140e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aa20e4937803d2794230e8713d0bcdac621c1257f43a91428611c7e75adf673"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go", "man"
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "hebcal.1"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
