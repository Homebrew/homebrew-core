class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.0.tar.gz"
  sha256 "8facd429ea7cd8d384628d70abbaef96fe10e31c4086861e7bef37761a0bee70"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6c793d519939a51a7d2c1d487e2083dffbeb47b85e036603cbb91ff203cf028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6c793d519939a51a7d2c1d487e2083dffbeb47b85e036603cbb91ff203cf028"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6c793d519939a51a7d2c1d487e2083dffbeb47b85e036603cbb91ff203cf028"
    sha256 cellar: :any_skip_relocation, sonoma:        "f54d246226367ad71b729d8915fbff880b606399c08306b836071f608e525b11"
    sha256 cellar: :any_skip_relocation, ventura:       "f54d246226367ad71b729d8915fbff880b606399c08306b836071f608e525b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a4e358aad67562c39dd7b824d8ee2b38172940b39860fb20e77715f0c39be7f"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
