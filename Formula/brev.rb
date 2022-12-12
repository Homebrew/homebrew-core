class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.188.tar.gz"
  sha256 "9cd073eb5776313c2af3a95d42c9ab511652df2be0bdecc271c45a861a3eb812"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4143cfa39b464fd977e2472c522a17508c78488c920d8a34354281e7bbbbee79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056239c05b2a93dcb7cc78fcfd5b7de19203b6938a39641a091d0bf927f3af07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9befa2dd14ce7f8c4bb2b0a2cde2af8d2e289b317ad5f06b6462bc727c052d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "f49d8b6ef0fe03b9afdc044e53b7ed2292b4baa83db76a7ae0dd72f273246407"
    sha256 cellar: :any_skip_relocation, monterey:       "24c670b7276af7d72497c59c1839c19f7b1671e7dbb7e28537e3e258490c1a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea3ef909bc0297efe14bb9487b7c76bc21420b01f11c5e0388568cb08cde96b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df921d295abb9274321121c8d965980baa408796118140213f305569025e548b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
