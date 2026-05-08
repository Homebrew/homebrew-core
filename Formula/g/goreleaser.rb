class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.15.4",
      revision: "fd20dc1995cd5eb3fded997d6613c7f694ab448b"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "413de1ef6add46617f0a21a0e8ae5d4d28e69968ce7ad299b45323e2f89eb61f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a93a46ead6698b067df9d4ce63223a266a00da49c2a9a7089efc4ff5dc167ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "582403fc72d5344c5d656c53072040238ca5ce574f2a9b64b47db745f768d2d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8833327fb80333f27fca2ae565633498be3fdae6b4c5b3f84452634cf26d479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d69f83a67b219a4f7508e4d975b219b07499ba5ba27e693fa99fc8d91752943c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae60095b42ed594654430c293a159b5f65f42bd14852505b65a093aff4d035be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
