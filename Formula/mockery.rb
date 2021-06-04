class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.7.5.tar.gz"
  sha256 "df55ac9f2ed6eef40b8fe2aea134fd59b49d5f2e6e66431c2ade15eb0aff272b"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93f9a0772adeb4291c990431d799a6547490668c022bfdb92ea19449cfd8d54e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3d432812cbcec794e44d8fc4fb68dac9a5eb092c66b1912c40c5626150f4975"
    sha256 cellar: :any_skip_relocation, catalina:      "1281d18b9f042eede7961615be08bbb1a6efc74134341c1f46848ec3128f29bc"
    sha256 cellar: :any_skip_relocation, mojave:        "561ae602e8c5b028168d102af54b5a169d2aa7fd4bbfdfbea5d1463d15173e87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
