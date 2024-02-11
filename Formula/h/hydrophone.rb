class Hydrophone < Formula
  desc "Lightweight Kubernetes conformance tests runner"
  homepage "https://github.com/kubernetes-sigs/hydrophone"
  url "https://github.com/kubernetes-sigs/hydrophone/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "7108d427906552138881630a77eb8765e080ccbbe491f1aaee87beaf1db58565"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Hydrophone is a lightweight runner for kubernetes tests", shell_output("#{bin}/hydrophone --help")
  end
end
