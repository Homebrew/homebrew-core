class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.3.tar.gz"
  sha256 "b425463ea3763ce536d28cb55e1fbfa4a675d6884e4ecdf84d19fdbba1c1b520"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c60906cc9905e6c97e7efa06091a61c69fa5834751fa80874dc66bad7735bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15c60906cc9905e6c97e7efa06091a61c69fa5834751fa80874dc66bad7735bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15c60906cc9905e6c97e7efa06091a61c69fa5834751fa80874dc66bad7735bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58a09c216c804e348a318c9a1cd97de051ee9615866977559c4d81b404d0bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a37bd7d543d1f2e3b12a0db3108414a430df4896ed9846bd6bda72e27f8e3760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d02e2e40980be8ed9266488f64deca3b0e3568ae3c7ff138d36e3090d960f6"
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
