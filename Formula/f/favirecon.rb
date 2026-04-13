class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "5cbf98b2874f1335ecac948be3fdef328cd3ab1b04706c761b79bbf8207bf19a"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97f00e3f6d3b3c9f06c626d58807def207b9926b209e3a5f94369595dea2eb4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97f00e3f6d3b3c9f06c626d58807def207b9926b209e3a5f94369595dea2eb4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97f00e3f6d3b3c9f06c626d58807def207b9926b209e3a5f94369595dea2eb4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7557971886c2b8a8da6acb77e6a37bf1377e171ef29dce82ce0d4d5d2b876fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb76be2261c77be7059bdda23ae2c8931eeec41bf4fe0ab804eb3636e2b22a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e382dce2daa6de20426e44010adc1205f1de8bffbaa08a8874d1d00b9e5e08a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
