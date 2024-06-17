class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "4fd8171cfd69b3631d8801d73c33c87f304df55bb8e231b40f9ad11c6876464c"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5489a17a6325a6950cdb119ee9924e7ece528cac4bc354583a7dffd0c3aa8cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cb4614089b7f0a8149f1cbc9688768211f440624def51ae393a2cc70185d073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7798b6fd37be0993eff24bd61fa27f8b4eb50ff93811420bbbf8268a27b3139"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3ed8c58ae42036fe9dcb6d5f7b134c7f87a5334c356eb4e9bc819f7e0ce74e2"
    sha256 cellar: :any_skip_relocation, ventura:        "13f95c639269935d46cdd577ef70ed36c75f04dd0e956259bba71f98256f660e"
    sha256 cellar: :any_skip_relocation, monterey:       "651350cb84411272f1fbb72a30aa5adbcfd235441cb15bcf02d51d169c4abc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b07fe2adfd97d65005a4d90c479520c8db48aa6c2f5f9448257fac7a3b7a3c7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
