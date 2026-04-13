class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.14.3.tar.gz"
  sha256 "d07f81e0dc0aa08dae22db9de2ac38b76b13afad84e1beefaa91694178f4c153"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "485ea63cea2a0e6e80bbafeaaf0a440a0cabd2ef6dd81c87783686f93957da07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "485ea63cea2a0e6e80bbafeaaf0a440a0cabd2ef6dd81c87783686f93957da07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "485ea63cea2a0e6e80bbafeaaf0a440a0cabd2ef6dd81c87783686f93957da07"
    sha256 cellar: :any_skip_relocation, sonoma:        "bacb4b9af494ad011fb21410e3edec784625b8f3994da6c7554971d285bfafdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431cfd30ed6bca896103f5399f2e879925b6c70ed466c4e52fa25a602a5db979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a654a8df8433747c7157d93655bbc113f5f9a9a86eb23f2763a3bd875e4dbd91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
