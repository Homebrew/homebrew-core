class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "d8eeab143703a9f98d0b5ea00d09873394db14d979510b836ad191e0b8e3a026"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47a1d403bd23d44cc3a58eb01a6266388c31443c6cad89d84199f10e7024da86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f870f992f9b241140fe3b0c9e812cb5c6318116c9eb07d13194e00a1d6f724"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7371190082a3564dd6b0fda4e3434817c255ae47e1ffc14eded65a02475cbb1"
    sha256 cellar: :any_skip_relocation, ventura:        "5b98c17ded1c3a8269a2e43de780eda1d2983dd7db1080bd2b3d91b0e1b35f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c2f80ceb2a8ce28cd0d5687fec5c21d711c4970844904d7eedea44a9b411da"
    sha256 cellar: :any_skip_relocation, big_sur:        "da77a530e3e29da03b143095d470e086c713a86f61dc81ade9a3d5e86b5ba426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c40a83a957ca7e82bd763b55ed44bd1ae664ba5dc51afd0f770ffefeed42d7"
  end

  depends_on "go" => :build

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "GoFrame CLI Tool v#{version}, https://goframe.org", output
    assert_match "GoFrame Version: cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
