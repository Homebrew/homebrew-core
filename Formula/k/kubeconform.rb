class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "9cb00e6385346c9de21e8fe318a4ec9854a8c7165d08b10b20ed32e28faef9a8"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fc0bd5fff9f4711f940b5e715bbd3a29bc6b95af8b03f93593c45cf35eb2e90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf8891c42d9a174f5b407e5a54ad7a18ec39e1413386738ad44a7f4a0e66257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf8891c42d9a174f5b407e5a54ad7a18ec39e1413386738ad44a7f4a0e66257"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daf8891c42d9a174f5b407e5a54ad7a18ec39e1413386738ad44a7f4a0e66257"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a2a5d5b68ca69d05ce2ead6c5e67e282c4a25bd31bee697ff0d8356ad38324"
    sha256 cellar: :any_skip_relocation, ventura:       "c4a2a5d5b68ca69d05ce2ead6c5e67e282c4a25bd31bee697ff0d8356ad38324"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5bff53c729946857a4eeb647d3ec19ea7d40ef99365c3995dda6ac19e66034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b430e93e88f9c3182f8e7a7c511c220e3e469564b4413d600815fc72d336bdb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)

    assert_match version.to_s, shell_output("#{bin}/kubeconform -v")
  end
end
