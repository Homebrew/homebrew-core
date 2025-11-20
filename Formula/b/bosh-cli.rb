class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.13.tar.gz"
  sha256 "d93fd17a44cb0a4068b862b79afb19bf72344ca17e15b097945ff9668c8c191e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "075403418c75d0156f35e2dc96ce58768b267a656d04c51509c4e53ad55a817d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "075403418c75d0156f35e2dc96ce58768b267a656d04c51509c4e53ad55a817d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "075403418c75d0156f35e2dc96ce58768b267a656d04c51509c4e53ad55a817d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9937549ec0e7ae2f5d31601b5d148b09327348991130d4f30bda4307b52469de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78bdee39efb6b8166cb6ef8802219f3a66220278e2ba4184ca9b129249a5cc6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1240e525a9fa79156ce9285aa7ed3fea7a49ead8ac6579530f17ff13f64797"
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
