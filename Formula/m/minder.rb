class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "4b2ad28301b1c351c44bbfe411b61368b1ecae96df74d0b963e8f5faea88a1e7"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7538acddd98ac96dfcf250bf21f6eab194fb10638df8b9a0030b3bf50e665a7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c0ea0223b5b40d8b64905575a0aea6fac6502eecdaa91777c9925a0972a19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f9b80b9fc9295d5059bbd010ed9ab56fe0e78a1f29cebf3ce5be5e615b68b87"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3194bc1fe6b5ab9ce4548613a5a20b26479ebc75e49456bf8ccadf266048421"
    sha256 cellar: :any_skip_relocation, ventura:        "89c3c506d97f84d5921dd3827b5d96a3ae184702df890311903518f4aab5fee1"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef404d9b42ffb687b9e09b82d14b12bdd1bb9a093ac0910f8afeee0ed401fbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7097900638af61e97cdd9710187c24cea7b87715d332514b24998165754a18ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
