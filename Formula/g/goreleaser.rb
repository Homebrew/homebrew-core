class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.13.3",
      revision: "0b78544f9956125fa41b2f15a6af68aa67484f2a"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a21741e97fefa6bf75bbbec92a09176c784a0dd627ec05cb513f50e13c888838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00c38b9d74daa3c810dd5f03faebb40095cf2449754f6ff310c3d0e44ee2e1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bafa40c87f2261247526d7c107a0d85d649102bc113168890b3d4cbf0bf1b0b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "39cad55ae0b8346a8701958287dd9006dd900973325292a135cb214e61579d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8813b79728b03b58f48b26f92f481954e3737bb70e37eef74eb6c94aa5e190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f135c3590b604714019d67351e7bd103985ee1d318f68dcf01f9e37eafcfe6"
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
