class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "1a6eb3e9a5084d0ce6d1a81628b314686b7cfa41124bace13eb188865f7640a0"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kompose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e46bf7518888a23e05d4c3f648f2a5c3f1b351ea12cc97de5a8c5b7fea10246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e46bf7518888a23e05d4c3f648f2a5c3f1b351ea12cc97de5a8c5b7fea10246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e46bf7518888a23e05d4c3f648f2a5c3f1b351ea12cc97de5a8c5b7fea10246"
    sha256 cellar: :any_skip_relocation, sonoma:        "12fc8c657351107f5edc64167953e0bfd7999a7a7cf3867b1c6435f034ba6133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b02fe2ef57a8cd7927d22e86066f72f2b245760a9b5c3fb9a7d5e92cee75a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b9e0b62ca787fcdd20f86bbac865380c349359c5cb46474b9313b89dbee155"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
