class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.2.1.tar.gz"
  sha256 "764fd843759d52f90c2c6b6aa89a3cb82d05ff26e2064b9109c908f7fd131daf"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ffe7d52bdd0161226a866115f12a3774c568c301d5d46e68d487aafc8905768"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cd1be1ad0a671ea3386b3bcba7e9912aed8bddf095ef4d8c6ed3188769d172f"
    sha256 cellar: :any_skip_relocation, monterey:       "329159ca71468d9e3f0762cf27739e07233d5b070558b4fb9c794a66ec8521a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "59dda7b22660551875060c42f6f9006578ea87b9bb0c0eedef6ad13e57e45091"
    sha256 cellar: :any_skip_relocation, catalina:       "8524a1e59878f8e49d32b8fa89049e5d3073f475f70a3271cb44161e16f6317b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6810c26023bc92628a7ebe1c024949f1f7f60969c6def544c48ef65442699b"
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
