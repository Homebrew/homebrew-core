class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v5.5.1.tar.gz"
  sha256 "e6e70ea574fd7cc846e3452fabfcb12e91126575dd9190cd48052df0a8272d6a"
  license "GPL-2.0-or-later"
  head "https://github.com/hebcal/hebcal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc730482b3a96b0fb96dc9166ce5ba3091eeb18c570426b57e5659f4f26d367b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc730482b3a96b0fb96dc9166ce5ba3091eeb18c570426b57e5659f4f26d367b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc730482b3a96b0fb96dc9166ce5ba3091eeb18c570426b57e5659f4f26d367b"
    sha256 cellar: :any_skip_relocation, ventura:        "76e9e0830a03bbc5d5ff021e2453d03d946ef3c634aec53fb41d28f40519efbf"
    sha256 cellar: :any_skip_relocation, monterey:       "76e9e0830a03bbc5d5ff021e2453d03d946ef3c634aec53fb41d28f40519efbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "76e9e0830a03bbc5d5ff021e2453d03d946ef3c634aec53fb41d28f40519efbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426e6ac777343cfde93720a150dd2d793ec63fc30fdc24ed2e7a9517b5524e3a"
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
