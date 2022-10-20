class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.2.1.tar.gz"
  sha256 "764fd843759d52f90c2c6b6aa89a3cb82d05ff26e2064b9109c908f7fd131daf"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90848ce5846d89a71503748718974f1634e13c6db55163fbcdc1ad3d092e4246"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90848ce5846d89a71503748718974f1634e13c6db55163fbcdc1ad3d092e4246"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc0b94abefeb24f0140033c5c0d4d918d53dd60a5a91d7a468587d46e5b6a61"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bc0b94abefeb24f0140033c5c0d4d918d53dd60a5a91d7a468587d46e5b6a61"
    sha256 cellar: :any_skip_relocation, catalina:       "5bc0b94abefeb24f0140033c5c0d4d918d53dd60a5a91d7a468587d46e5b6a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fca57c3a508d02dc07e20431ea62e234ff3569f7eabf1572349e75316ec9442d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
