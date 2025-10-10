class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.5",
      revision: "8696231b52efc02e322102545fbe97a74c4a60fa"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374faeb33b5321720c9e3b5eaf30c3267ba16b7b2c150f9d565f4a653c56e31f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374faeb33b5321720c9e3b5eaf30c3267ba16b7b2c150f9d565f4a653c56e31f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "374faeb33b5321720c9e3b5eaf30c3267ba16b7b2c150f9d565f4a653c56e31f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e00da45d72f0974ff3ff2ce9ef316323985225ef99eab7fc97cfa03770fe1bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb047c00b3b0f8a62741ee4aac526403db9c725bd0390f5e0e0eea9abb3e6995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a198a318971ead453918a1ffa7ea6c5ba995bb7f26466b2bbd9b165862c24c1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
