class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://hebcal.github.io/"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "64f263e81de54b13b8b3d2bfae49bb1e7b71da6851ab71b038c06aac679b960d"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c42a164b98c5a5efb697a90c0803d4d4360a2e5475613cdd5456ee5cd9a2a253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c42a164b98c5a5efb697a90c0803d4d4360a2e5475613cdd5456ee5cd9a2a253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c42a164b98c5a5efb697a90c0803d4d4360a2e5475613cdd5456ee5cd9a2a253"
    sha256 cellar: :any_skip_relocation, sonoma:        "d267feeea5667151aee5720e32128208439d03a321ccabfd2a9487ee29825f55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1993074fb1a23f36f0ed6f1a429f3de3252f7b134f2590357b0d4c7f3c8cadce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4bf4f37c1b11cf7640e976ac5631d2a861cfdf737f3422ad2818635df2a761"
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
