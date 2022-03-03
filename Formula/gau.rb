class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.0.9.tar.gz"
  sha256 "3a83671c77e6040ada89f8a53e7cca566b67cc9a2b2c788d2f1d782f365adbf4"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94b9fb1ae39b235596dea6ff2259f0cacc182496e49586cbcc5b6b1854225745"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5593c85afbab96e6a52f9764c72b7b8f205c76c10276dff8b5a0aad44e0f27be"
    sha256 cellar: :any_skip_relocation, monterey:       "9e06986ce5bbf8482d9b8b8f5ce1aaaa93f48be825cfb099dbc12b9ae9744b5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "382558664ef70b3b4c8a81097b609cbc4e54730c5b24ade3781f4c309dd795fc"
    sha256 cellar: :any_skip_relocation, catalina:       "64b2acc2c15b8efe7bad6d0472d34a14e18b41fe88a7f11879dc5ed9ef3cbcd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b232e161d1d7a5fb8611ed3bb41ca8cfcdc7276b3bc4343655516648df1c7a9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
