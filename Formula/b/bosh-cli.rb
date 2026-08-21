class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.10.tar.gz"
  sha256 "72e1bfbbf920edfb3e4bcec0e8e9c13ee1c3e9015e2cbf7d858bdc8220c13287"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e3a91310519e9af82a4777a7336445d6692b16d6a0b410837909046276182fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3a91310519e9af82a4777a7336445d6692b16d6a0b410837909046276182fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e3a91310519e9af82a4777a7336445d6692b16d6a0b410837909046276182fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "be46848d48874e3bd17c33a2be489aab6d5607297ea863efdc602e111f491236"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecab199d86034179358c3d1030d70d23132caf2c22f29751acf549d104bb2b7f"
    sha256 cellar: :any,                 x86_64_linux:  "6d4daae0b0d4333e5dfd18fba4abe3fce99f25f800ee49b327131ae02311a271"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
