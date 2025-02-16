class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "b954fc1a4b0f32aa69fb42bead45a87410fc23cbe21e0a3d57b615c335d48b20"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2511ccd38fb8fd049b44974efd6b8a212f97285df367c1e589fcd89719477d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3d3e8c5db5052fc9e64ff0de7ba2c309c0eed42b0e88d8362e3e76e39f75d65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74b53b6696a96e1a7a6da3692dea0725e530dc3093057b81177d6b4788aa13c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b0ded01d984400c4219b3d6c9e26695fb9fef92710b0b3697599204be81eed"
    sha256 cellar: :any_skip_relocation, ventura:       "ab67378bea957d3d7fbc5cbeac68eafe69bc174c54285560d5f5f6c76c6858cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439b66b478299040ff99e6689b3880466dc956d67158160edbe2269ff9aa36cb"
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
