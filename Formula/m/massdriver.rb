class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.5.tar.gz"
  sha256 "752e4696b2035b0725a72365fdead38c7e9d1b3ecc4827032e7d765a4d539a09"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2039713468a3a0f7dab279e4606ddc6d10b14bf9593789d4d0349167fd189e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "776f86ec02e651a4e13a3c8417e48117013051f61744da4848600474f709d82d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a31cd50350e3b903e73ce22b12f2eacf7592c6b98e798649bfbfab2ffe6fc967"
    sha256 cellar: :any_skip_relocation, sonoma:         "e14cfc38c9032b37da8cadb3b7e0562253a644413c834f2f0ce643dcfa2b8a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "8960795d03843b9e67cbfd7fb4c7f6c59f0349502e62dad17a9dd9cadf5824cb"
    sha256 cellar: :any_skip_relocation, monterey:       "163e4637c56b66b56bc84b1e4744f5a94c0a3bebc9f581d0500df1568e86cca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa9d1d6667a84b3d784f0c2e78ab5542bf6d63700ee716327b790b57fdbe240f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
