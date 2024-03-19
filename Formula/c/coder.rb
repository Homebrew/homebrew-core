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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99aa19e9400fe7f4e6480af5f54a4fc9ae1231c07315f851c3cb3b6401f6784c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab584c0a205cfb901795a7e676e7c3357c1496114a019a24871d9d4f2708be52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18326e18fc461e9553dec036d6fc7eed2a08a1676fd6a26c8555203a520044de"
    sha256 cellar: :any_skip_relocation, sonoma:         "58edb8d1f66fdbcc94eeef43d61c9325ae732edfd39364a62788e010d3888e2b"
    sha256 cellar: :any_skip_relocation, ventura:        "100ab9511379f023522e0cf0d05a69a996f392499c143e51118726e80cd3d220"
    sha256 cellar: :any_skip_relocation, monterey:       "77ca27c6e4dfb8d8beb6236b4285ed76a2c19a783c953b632e0e5866323f6df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70fcdbf6a86d7b077724ad2252ac05d49e35082d15fbf48847eb5b25c6c13211"
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
