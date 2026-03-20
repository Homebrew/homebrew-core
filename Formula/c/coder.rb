class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.30.4.tar.gz"
  sha256 "5606bfae4ef497fc1bc54087c600b1570a90829689286035cb3e79fa8275e61b"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4a296679cec9751fdfd4bf11d5aaf5d55ffc2b696672f3775923c78542013e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100d41df5f5a6a336795499d4e55795cf0035216c37a3c0b6ae801bfe2d45bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ab4f227c6b37b39e98573517aa2cacffd2ad4c276217259ca327174f444628"
    sha256 cellar: :any_skip_relocation, sonoma:        "8961247df14f8f3e1accec99c9e88f25228dce7248fb0b926104e7812d8b5a7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb795f8edb2bfeddb3c1ea395990ef8c8dba8d8affab2ffeebd255a4451dfc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "856c9579ae0915fb45a9a26fb11fc9179e0287f9acb8bb5e74dfeb5587ca9dbc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
