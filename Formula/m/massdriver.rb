class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.4.3.tar.gz"
  sha256 "149c73fe52ea3b8b9f937bda4ce11073912b3a6132525e4036760b32d17ccba9"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9933bda4732259cef2868c460aa42a856a976620d1d5a807f0f1da8ad9bef905"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7504a8630c2b43eed421344d1db7a83447bc9cf7787f8e2a3c88765410fbc950"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7383dda548a2ae3193777714bc16e350c3c1aadd89748403bd643cf3d9cd17e"
    sha256 cellar: :any_skip_relocation, ventura:        "56892e8975261e10d524aa7101eb1945f51178e5497f09a9c81d102276f7567f"
    sha256 cellar: :any_skip_relocation, monterey:       "9df2716a2e8d9ad628d8ff32c3771b8acbd5f0bc8c95efa50caca615503838b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aad5c5b890e2e2efd9ef6d42adadcccb087927e31a947829bfe9a267a953e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb8bcea7f60e6d3a4219d4621492fd4e6b4b1361735911dea2177f5b7d9fa1f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
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
