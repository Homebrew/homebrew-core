class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "06967b713e6d03a94161c6e41609dc58cf7cd8115e8e208ce7a27eba2c3379e8"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bdf4ebe80e105eddce4cb8c9afc51e203ffb1bf1c3d2a0856909ad102d0f9d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a1b6049b11aca1a121fa772b569d81790158a39d0f266d186d6bc1d6e948eb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad269dcdc0da5af544815f60612c4f343c89ebeafbb7614c3b68915f4b9a3b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7633e3f9ea4aa9a6f185eec9bc7ba84e996762d7a806129c317a9d2c546437c"
    sha256 cellar: :any_skip_relocation, sonoma:         "75fc3c3991c4bad05c2bf2ece8de1ef53b947d1aa6de3d6890e7fb5be0e21a68"
    sha256 cellar: :any_skip_relocation, ventura:        "8052e315a6ea72e376f6e279fdf86a7a08ab8d2700dd51b06a9404d92df7be64"
    sha256 cellar: :any_skip_relocation, monterey:       "25d159e6dd6cb2232c3348f9b5711270dcdc24c74d0ea7f9c2dc0d940750d9aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f6ed07e24577291206a1c9121a1e012ef84f33d8b448c2ab830e06ad964e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74ea521c601354e114bdccac623046e76651853350d60959bccb35e122e35038"
  end

  depends_on "go" => [:build, :test]

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
