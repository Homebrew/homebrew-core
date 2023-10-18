class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2d2647dabfb174060b626120142848bd316f2c7a4bb0fcdcc6c6fda31ea5644c"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "164a08192676742c70940f22564ad72cd51872ecc209ba7083c553db10483f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e2176f72febba3b32d8ee68138c10c7769ed184cd2e8aa6adf8a54c4f744006"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33ef3758a6c38f47ad5a5f6c01d2c659da495a7686e1312f9db04ab9ccacc055"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a4b5820950fbcabd263818a0c533edaa7c0883dcabc6a303ea72e70cba88116"
    sha256 cellar: :any_skip_relocation, ventura:        "37fe9bd476ec858b3b38c2bcaee514194bf2286894fb2b1821b90cb9687e6ae9"
    sha256 cellar: :any_skip_relocation, monterey:       "d7e8d33bde44b7a320f2a87b3cc6de80f11e200a292ddd0c031fee6249400b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e54b6f3e897c0edbba20db34f858b10f0ac4a09fc6b797b1b61465f569fa5a9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
