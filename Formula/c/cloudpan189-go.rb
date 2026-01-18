class Cloudpan189Go < Formula
  desc "Command-line client tool for Cloud189 web disk"
  homepage "https://github.com/tickstep/cloudpan189-go"
  url "https://github.com/tickstep/cloudpan189-go/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "a215b75369af535aed214c94b66ebb3239b6ef5fcbc2f74039cf9c3eda4b04c1"
  license "Apache-2.0"
  head "https://github.com/tickstep/cloudpan189-go.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d292a2bd969d609f7f5f005b2f8e59a4a3807dfd6271d2e01d1b0d5807d1bae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "793542588a08328d55060fc0faeb3808bde9656eee00e8df0b9ca98ad70ed9b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c66a3ce0426a356d4b5c05fe95fc6213ed4c867048157ebbc862ca9196af857e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6870cbe4123a3eae721cc676130d2146794d9a3631268d48c579430a923173f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6870cbe4123a3eae721cc676130d2146794d9a3631268d48c579430a923173f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6870cbe4123a3eae721cc676130d2146794d9a3631268d48c579430a923173f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0259637185f73febd2da780378accfa232b124b8cb46aa376a64ce5adc319140"
    sha256 cellar: :any_skip_relocation, ventura:        "6ab13514be4a47d60c22436daad9bd2ca0612b61eff549630d8548cb24405424"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab13514be4a47d60c22436daad9bd2ca0612b61eff549630d8548cb24405424"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ab13514be4a47d60c22436daad9bd2ca0612b61eff549630d8548cb24405424"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "42247f05683ad756a121dfabe4afd9074ad416ea13d681670e686dfb1b4cb68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c193bc56690eef410bdbbce6d6b774fcf658f16b114ea0222afee18591d361"
  end

  depends_on "go" => :build

  def install
    # TODO: remove `-checklinkname=0` workaround when fixed
    # https://github.com/tickstep/cloudpan189-go/issues/101
    system "go", "build", *std_go_args(ldflags: "-s -w -checklinkname=0")
  end

  test do
    system bin/"cloudpan189-go", "run", "touch", "output.txt"
    assert_path_exists testpath/"output.txt"
  end
end
