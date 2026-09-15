class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.333.0.tar.gz"
  sha256 "54089c520da536431f3dbb478024a5f103607f7650e518e09d82c26743e14ff7"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bd1fd043f0a6b15066b0da5a882234a080ab1d7176c3c6047c38d61f2aa6b51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c65f9ec37f89eb82a360b2e8edd96a9f6291918aaa4895a238f0614a7a2d4677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "19d44e650d6398b6f2a89ba7284e5e4ac4b6b08297224154af7263c8b93d50e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a7cbd810990cef6874515d9e2cd5f43c897090518b059ff87d4ba5efb767fc53"
    sha256 cellar: :any,                 x86_64_linux:      "3ea838be5fa3c526f0a18ea2ce4f725080aea2eb21fc029d9c78c8c4609c8c87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
