class GithubRelease < Formula
  desc "Create and edit releases on Github (and upload artifacts)"
  homepage "https://github.com/github-release/github-release"
  url "https://github.com/github-release/github-release/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "6e6d3d77ce7d6acf6c4e4e0e005c71641ba7c2eb67d9f1f2e2cf2cc5f5c68086"
  license "MIT"
  head "https://github.com/github-release/github-release.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a699dd62fac62ae63696f53b9bb8ab1daf2dac9fa89d3826c97bf99dead45c60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783735e7a1d5f4bc00ebfb61e97c31b815af39718562f6efd8b3aa228600e2b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783735e7a1d5f4bc00ebfb61e97c31b815af39718562f6efd8b3aa228600e2b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "783735e7a1d5f4bc00ebfb61e97c31b815af39718562f6efd8b3aa228600e2b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a20268af91f08bc5e7eb972f9713dd0d5a9cb68be43a0e16b1e822bfa4c7e71e"
    sha256 cellar: :any_skip_relocation, ventura:       "a20268af91f08bc5e7eb972f9713dd0d5a9cb68be43a0e16b1e822bfa4c7e71e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4288f2f1c32a376ff28685879e6040efb1463f6670289ed3194f72e89ceb4db1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "510735d16c9f1d621e3012a676d55ec0b72a6fc1a9d0a6476c30a84ba627daf0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "github-release v#{version}", shell_output("#{bin}/github-release --version")

    system bin/"github-release", "info", "--user", "github-release",
                                         "--repo", "github-release",
                                         "--tag",  "v#{version}"
  end
end
