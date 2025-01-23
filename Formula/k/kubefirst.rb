class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.7.9.tar.gz"
  sha256 "eab611809fcd55e576a5a745ee43bfc7f77925e35c3ef6799974370acea3e780"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1167dae7f2885dbfc9026201fdcfe0fc9da1b55156071aaac4d468e58d3e9d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d537e9689fc03403d7807d2350e50cd3675948d9f4742e67236d3c2673934339"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b4ba27b1dc3b9aaae6ff7ed110a427d32365804c488616e24b48724ecc9061"
    sha256 cellar: :any_skip_relocation, sonoma:        "48ae29e6919e39ce21e44fad1579adb5784c36fc415307df8fb9db5d363950b3"
    sha256 cellar: :any_skip_relocation, ventura:       "34866fa21a7842b681fcc3564e479e4398170f9db50f78075c64d1ecd6a7e4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20aba1cb96aff1d31ae2d49a2784798c829210db6346915e366bd4df40de306c"
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
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
