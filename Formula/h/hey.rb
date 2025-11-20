class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "944097e62dd0bd5012d3b355d9fe2e7b7afcf13cc0b2c06151e0f4c2babfc279"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d874103a6d01bbf42d67d751f9f8b88c49d75f3051bee0b1b9c7e164aeb1f156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "11d051b5a740c4932cdbb39fa8e3abb465b499b0dd24831b0649fc37fb9da5a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7240c725e9276fc11ea1a59f748219c34b26ef36fa299644cc676ebd459b92ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04967df199323ca6ba0df1731c05185bdba45fb9379369608e2ba43806f6bf40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31facd23bb601b3b20819401fd535eb3415ae7849c3989923226e368897c3248"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45175c81eb26b54fcf4b865e97a3a075ea12a85657884aaf78d2626ee07232fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce33b37c801d64c65b13f7a1d7e9c8f84bfb9cff54fbfca2656cea9884c0f021"
    sha256 cellar: :any_skip_relocation, ventura:        "a4b5c5c6bfe7adc7c696feb4873346f2054ee268a04c483e2a29510d5b8c5d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "55e5e3fa15f75e97aae934d9e86319d54af49275eef765241b05415e608c2791"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a743f02a2abfd8fa424bb9ddc8b65ba3633f6b3b7b216da6763a5fe95c10501"
    sha256 cellar: :any_skip_relocation, catalina:       "972cc3f6a520467db11ab9cef3aa5311c6813c203c23bb0173363a00a45cfc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a0b6c6fd1de183a79e5f525ddda5723398a215b2658ea3be0c45d51101b8e1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5454552b0eb8d412645a0a5211b0566a41d13fc238149177bfddea36ace56e4"
  end

  # no commits over the past four years
  # community discussion thread, https://github.com/rakyll/hey/issues/269
  # `oha` is a good alternative
  deprecate! date: "2025-01-12", because: :unmaintained

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://example.com")
  end
end
