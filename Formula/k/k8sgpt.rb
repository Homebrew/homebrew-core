class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "ad02c1139bada81ca82337c1fe4d28a2c004738278280c10a8b5d7e413c73ee4"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cae90839c41bac93cc1a7e8c778bf6c8cc124d4a2e06c80e930b3ba9bedee16e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "967556e1cfb737a82bc1e4056fa76879886a4635ce5e9973e877c8fab692c9c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b3c277ec75d9c74cc9dac2d7b8a8502782677ed4703e7b6c7a649963335e48b"
    sha256 cellar: :any_skip_relocation, sonoma:         "54bcdf005cfe788425c21e7e0af9f88e87660d16730c720238aea141bf58e762"
    sha256 cellar: :any_skip_relocation, ventura:        "b7ef3a60865f80c956bc5e654d303185386bb5c7b5113f551ae789ad80d2d2aa"
    sha256 cellar: :any_skip_relocation, monterey:       "349c9039172ffad4fa9da1800f20cba0edda60fcee592634ab31141cbcb2a208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e02b0b37ceaddba0125eb80b6e5f90082759f990aa5711b4a1f842765864c9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
