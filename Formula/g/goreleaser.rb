class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.18.0",
      revision: "a38ac3174c591f95049234d25bb326104d3ca820"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba23126d88d7fdee3747718432b16c35e4c1f36ec8f82fdece1ec8c23a54268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20ccd0f52408f19a6bb92a54f3ead84ab90f0e35293a953924913b9335f628a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01d56bed0712d05515ebcf812f1d4a29c071b9be0179e82f341a48853c03ed82"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b49a9a93665f97e900e94c03037bf0b95f77bc835e9655823ee77ccf337954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb03b2a8dbfee2823bd5da9356e06bc7c384f441c30f253852dea21f1881e168"
    sha256 cellar: :any,                 x86_64_linux:  "7edcb6789fe7409bae311569f799d0b00ebf6cde3a6bf0bd5402adde91475af3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
