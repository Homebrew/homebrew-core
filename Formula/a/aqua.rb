class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.5.tar.gz"
  sha256 "e166ee90e7db5cf1a6bd056b95e57f39f1fa6c04dd84ecba8f544661d84fba18"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c12b3a938287080f06d21005655b46bf2a6de94d0ecc7481b116136d7e349a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c12b3a938287080f06d21005655b46bf2a6de94d0ecc7481b116136d7e349a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c12b3a938287080f06d21005655b46bf2a6de94d0ecc7481b116136d7e349a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "509d9c7ef60c60944e40bbd6e074c461bd7ed8ae5d2f79b12af78bfc68d166f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b5a95dfa61bf17d6f04a24bf4d1cf2aa71dc421e51057090fc543d6119a49f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c89d315d3c0762fc88d8c8631937289ec8c50f275779c8a5e5896fcfe6168c94"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
