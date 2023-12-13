class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "2e1da048bba41e057998b6c84bfe50a5c589fab3f7dde473008344ea0b01d759"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "624a0bfe3f8f6c50380e5309c98cf35c0efb3639aa1e992ca68670831b5669d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c64ff7ac73d37b87e18ba6d03a748e8ca8e2aa35a067ca8b400dc010b61429"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591d7ec77fde9d317dd2f78cd35e87c18d42aa13cbbe0730cd8338af80312f10"
    sha256 cellar: :any_skip_relocation, sonoma:         "80cfc90ee8bf6dff7ab7c698f0dab5ce09d1522d371f2dc84c8a5132adeb7f84"
    sha256 cellar: :any_skip_relocation, ventura:        "eea89b25a1bfecf141f63113728fc1fc898929d23062900727eeb200b4940c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc547f1007b732800193ee2b2ff17a733e209b0bb9d343e228126cd9933cfa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9901d1aae8cfeb87c6802eef4093c01cbe3488c07b54bdd010ca72ec3122c37e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
