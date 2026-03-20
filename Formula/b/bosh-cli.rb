class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.1.tar.gz"
  sha256 "875ec391f3086f71670b7e77581a12d2640c94a335e66fa1c2e05954c8e58db5"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68bf9ea73768cf8379dfdad51bd5faadbf195057dc7194edd25051482b3f951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e68bf9ea73768cf8379dfdad51bd5faadbf195057dc7194edd25051482b3f951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68bf9ea73768cf8379dfdad51bd5faadbf195057dc7194edd25051482b3f951"
    sha256 cellar: :any_skip_relocation, sonoma:        "a33581a869ae3eeb297b8776ee2b01c79c32f14aa9f0cce014359e64b5135ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40ace130026ead730ff33f4ada6b09d171a74ae064375ca4e5153c9523b1ff9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c76be2bbcb81b873f33410cf5bfbe0595f11e34c8056601e5bfaadf258e49d"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
