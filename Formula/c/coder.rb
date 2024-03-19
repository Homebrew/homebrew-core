class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "1a6574bc19f0ccb859e1ea7564e81c7b607c806e284604eacb24fa08d73918d5"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "855acd5357740c5086bb9ff4d37c0bfb0cc2e33ea731e3b6644f78ee8311d737"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4be42752ca9775b8ecc09b0e635eae10b58e7c8fa0a16ac5b82fed6fb0db7502"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b79f5f3a7087b1f9eec41ea4e3da034a448a7be313ad76a265257afbc76940"
    sha256 cellar: :any_skip_relocation, sonoma:         "d16f5d6e9f2a60cd5730add605a59b98a0b0821fbf7f07e541c33429320e8f94"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b7451abb3ae8dfb1b7c2b147271c6af46f4c54b4a7b37d7ee39df77b014f54"
    sha256 cellar: :any_skip_relocation, monterey:       "35f1d2a05cbd38e325138bf957244e8f6f57af780621cb399bed0fb81c79cfd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab64200bc90bb8da220d6a0511af16c8e73816efb53bcf3c3cd7596bb13f845b"
  end

  depends_on "go@1.21" => :build # see https://github.com/coder/coder/issues/11342

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
