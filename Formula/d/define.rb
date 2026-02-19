class Define < Formula
  desc "Command-line dictionary (thesaurus) app, with access to multiple sources"
  homepage "https://github.com/Rican7/define"
  url "https://github.com/Rican7/define/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b8f0a83bbf345330d1081634e3b865527d4924be8e771501283abf17c4304514"
  license "MIT"
  head "https://github.com/Rican7/define.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b47971b7497fb628d7adea9bd2d657fc4b46ddd2215f8bc388287db13c845d0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "70a825ed3661f2536ed9680f5921d5074247464c0e7f3fd3d7c7c93bef9dc7c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4882bc1b7b4cf9f7bfa1181ab067820042a45077ba6941b9a0966546959e7e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c301e8ee5532ce47928989534de2bb2b07c2b1361b47dad059bb3aabbeb5642d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301a61ee7318cdac3c0e4fdbec3bb4a38dfe7c59a33c56f73b5849024ecfc525"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a7046386262e0c8ead170a8ae73d20ee45eaaf0827fa6e5877d34a27dfa3f1c"
    sha256 cellar: :any_skip_relocation, ventura:        "52b5e52db7f2a1cd770fb042a28781496fc7c15bcd441fc9d2b0ec24ccfba3c6"
    sha256 cellar: :any_skip_relocation, monterey:       "f7e89c50d429ffd8a461b0124838d1425fa7b9e06f87889952ce942dc8fb3cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c9855c15c07669af36ff3940ef7df1b025483855f2b74f0d1c61833a399dd66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ed09144379f9439b144f3f4e93e394203057f479d9edb6309fadf11183d17c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/Rican7/define/internal/version.identifier=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Free Dictionary API", shell_output("#{bin}/define --list-sources")

    output = shell_output("#{bin}/define -s FreeDictionaryAPI homebrew")
    assert_match "A beer brewed by enthusiasts rather than commercially", output

    assert_match "define #{version}", shell_output("#{bin}/define --version")
  end
end
