class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/refs/tags/v5.8.3.tar.gz"
  sha256 "9d5bc2837d961e822261af0f28fbed379c7d4ab22c68b4ca9c156c56d731fad4"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5685301aafdc3655f86700367854a7d2406e9c25e875445f62a3a4d65c24ebab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5685301aafdc3655f86700367854a7d2406e9c25e875445f62a3a4d65c24ebab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5685301aafdc3655f86700367854a7d2406e9c25e875445f62a3a4d65c24ebab"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c2e60c1b16b709e13222cf8a208654c38a5af3eb12b1026b3c4544050641964"
    sha256 cellar: :any_skip_relocation, ventura:        "7c2e60c1b16b709e13222cf8a208654c38a5af3eb12b1026b3c4544050641964"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2e60c1b16b709e13222cf8a208654c38a5af3eb12b1026b3c4544050641964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "001cc65c23aa230e30ed726235876beb4598f9534953ac3bc7aa1e665b75898b"
  end

  depends_on "go" => :build

  def install
    # populate DEFAULT_CITY variable
    system "make", "dcity.go"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
