class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "bf388bd45674ff25bd96ebeb42f5509b2a5a37495d0e44c5d14b5d9580903c6f"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d87d70ab4326dd172d9759d8003961be0954a9d91710508e9b0e5e3bf5d4a177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d87d70ab4326dd172d9759d8003961be0954a9d91710508e9b0e5e3bf5d4a177"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d87d70ab4326dd172d9759d8003961be0954a9d91710508e9b0e5e3bf5d4a177"
    sha256 cellar: :any_skip_relocation, sonoma:        "fefb9a044c62f902141842cd069cd656f270c39543490af4be4440889ed080e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdfe72441e7e434762108d468219fd92f46b113f9d53d87ab809a66c660cd216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6746c1d58ffdc00d2a6eb3182993d65b6a73204b8a67df18faded638866aa1cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
