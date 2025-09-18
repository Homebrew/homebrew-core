class IcebergCli < Formula
  desc "Command-line interface for Apache Iceberg"
  homepage "https://go.iceberg.apache.org/cli.html"
  url "https://github.com/apache/iceberg-go/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3bf2bb338676161db4896b1748879cc211ea12d9ad9ea5dd845dde12af271249"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "164e0a2d79b07b6d1eb0e7acc2da2496f540fe74ceecaf925382693cf1e7ded5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647a30360d91f967cb13355a298d5eaa17aef1a33fd80b40eeb832225747d77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "647a30360d91f967cb13355a298d5eaa17aef1a33fd80b40eeb832225747d77c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "647a30360d91f967cb13355a298d5eaa17aef1a33fd80b40eeb832225747d77c"
    sha256 cellar: :any_skip_relocation, sonoma:        "98428be6efcefb5a5e390c480b89e26424da60ee1cf0f56624a1c5f9c5f91f20"
    sha256 cellar: :any_skip_relocation, ventura:       "98428be6efcefb5a5e390c480b89e26424da60ee1cf0f56624a1c5f9c5f91f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa20e65aadbb859fe41865cb7cce175052cba10bd729b5421a5a3f051dd825a4"
  end

  depends_on "go" => :build

  def install
    # See: https://github.com/apache/iceberg-go/pull/531
    inreplace "utils.go", "(unknown version)", version.to_s

    system "go", "build", *std_go_args(output: bin/"iceberg"), "./cmd/iceberg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iceberg --version")
    output = shell_output("#{bin}/iceberg list 2>&1", 1)
    assert_match "unsupported protocol scheme", output
  end
end
