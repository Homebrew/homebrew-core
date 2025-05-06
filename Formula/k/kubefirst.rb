class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "020a245191e8e247a417e623bd467e98644fe4456c0a2ca3cefa7ba0cda81c45"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "802f8bcd8cef477f962c58d2640fa06bbe993bf5c4499f0bd4b32f30e5b73895"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6193337592081faa0bd3c7aa1f0881e4a1a09ff0ba7eec7e76ba49c20a4f1a62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f824f371e912db8d34c3cb87b03fa27dd41bff1d590deaef592ee4a75c49b39"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cd14a498f4fde2cca1f8b90bbe81eb05efe280dd75e408db4299b2cacfa650c"
    sha256 cellar: :any_skip_relocation, ventura:       "940edbf4ddbe5edeca5ca6118bba9e2cdd463354af9f2770990346252674cdf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce88d2189bc3e4c77516411f23e792ccdb25ac24ef7a27823b5f713a006a3ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6cfe745f9bd922a71b445721c8acb18afe7cf538188dcd41c4f6a14c91bdf2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_path_exists testpath/".k1/logs"

    output = shell_output("#{bin}/kubefirst version 2>&1")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
