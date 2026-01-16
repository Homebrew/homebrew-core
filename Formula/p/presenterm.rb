class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "ce925da26d9a30e2eb319acafcbd4ea4734945b1afd59b12c925bf7650b2771f"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cdc1d99aaddb30950ca365bb4abdb895766e459e65552b39f2b945c4db5befe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3c413356d993d87b3d63f2add98cd8aff54dc14ad553e7f9697f770548358cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96ca4508224948ec574fd292332bb1376eca16523d13de6d2e73fdad4758aa33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "223dd7eaabaa7287e4273c2bdc8eeebdbd2f0d1d11b03e02f696d00580446739"
    sha256 cellar: :any_skip_relocation, sonoma:        "a620da9bce23a727936d36c0eeb86d5a7fd631a5d0da62b79b2d461f08545a61"
    sha256 cellar: :any_skip_relocation, ventura:       "ffd4a5041f06046713c8024a1e7a4daae3222c10f6a7cdc4440d9a1f902e8f55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c01c999ef3403e979bc4f612e75b23e64cea671ec41465468ac2b8e232b30ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75a974e9f0d1e38f6069da5247e9146c5308dab836ae009f4afea8ced039107"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
