class Notify < Formula
  desc "Stream the output of any CLI and publish it to a variety of supported platforms"
  homepage "https://github.com/projectdiscovery/notify"
  url "https://github.com/projectdiscovery/notify/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "b9883c8476f17465c7fced603382e6d3f379014ac7fae79a4bb61525a5fc63e8"
  license "MIT"
  head "https://github.com/projectdiscovery/notify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e411b5b9468f48b226fa153c02fa31d5c1cd8d0161d046f26cf71d86c1236640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbcdeaddfa6e07bd0a384256e33a474a46c6dee7cb5aeac07b8c733a3b290979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "214b76e2eac90c2840cf8674d8ec969d2eac99d7096962f8ad95e24d67342201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d0a64b137d86e2483df77243543f9f89312d3f3507fffb321869674ecf97f0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "793d832b4f1e2048f7a4c008b67885387873a38077a34923f5538e616c2d75d0"
    sha256 cellar: :any_skip_relocation, ventura:        "9b2bc37ca166b485bccb2fc9d456b8405f4d7281ee76b360c316f6fc4e561527"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ccb6a1b1609562d1912a57852193b19cf91aab2e196ec2a574b746f80168ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e69355106f4d76651e62c871bead7c2fd8bb22c5b8369cf3e5f7b158591b65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notify"
  end

  test do
    assert_match "Current Version: #{version}", shell_output("#{bin}/notify -disable-update-check -version 2>&1")
    output = shell_output("#{bin}/notify -disable-update-check -config \"#{testpath}/non_existent\" 2>&1", 1)
    assert_match "Could not read config", output
  end
end
