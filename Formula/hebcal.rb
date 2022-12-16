class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.6.0.tar.gz"
  sha256 "eb26d15a1ad186bde9ff1efebe8cd1238a2dd09a378a0d39989aed5057146347"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f538f34fd2d50ad9f47c2a3358c469fbadb28216411756c81eceff7d02d104f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f538f34fd2d50ad9f47c2a3358c469fbadb28216411756c81eceff7d02d104f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f538f34fd2d50ad9f47c2a3358c469fbadb28216411756c81eceff7d02d104f"
    sha256 cellar: :any_skip_relocation, ventura:        "0023899d5f5d6ec87ecb95704ad368fa45e60fbc645864628725e0001a799468"
    sha256 cellar: :any_skip_relocation, monterey:       "0023899d5f5d6ec87ecb95704ad368fa45e60fbc645864628725e0001a799468"
    sha256 cellar: :any_skip_relocation, big_sur:        "0023899d5f5d6ec87ecb95704ad368fa45e60fbc645864628725e0001a799468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58fdcbbf7b9a630d988dbe8a36c82b90cc3e703680740cef1f8f720c3d95235e"
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
