class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.6.4.tar.gz"
  sha256 "1d2e04224235247cd98347ac36a84271132934e2b56242ab285b125b3b0bf719"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82f21eb71fb4362ee5cae406316e77a7bd282386eeb81367132bc40895e4691e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a00f3f072121f0ff7bbe14eba436ff8f0d39e00875ab966570f51dc46096bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cfa69c85ad3ae6db994c6778feeec90d66b9330ae8b486f4cda5469340da4b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f75d0c8c29dd3dab1e430d0e5c3a44dc82c1d71ae1b50acd785c8d8a967b2d5"
    sha256 cellar: :any_skip_relocation, ventura:        "d4d159a21dfb9b9d98777fd2cfd6bb23b888fcc3b530da62d73ae39140e5ecd9"
    sha256 cellar: :any_skip_relocation, monterey:       "39d35de1a7e99d39c00aa0091c561b1a70ba6ace04186387a8913413f0ace899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af81905651b593f2a59cc21cdbd50abdebf08f879e79c45a4e931f3b4cb40c3a"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
