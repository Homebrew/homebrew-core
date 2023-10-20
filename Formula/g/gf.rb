class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "89ef638b81470e71d7e8008815be566963a90e2692ea53eee5fb0f7f48ac80fa"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa52a797805d8084e838341288657dad276a7c22d85cd1cb30907044fe00e833"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16282ff43ed7bf3da332a3ed3fc043722c60a4f0b56dd932e52a34dc65e0bdd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5b3a9d17d24441a229e88f32a5b06c73b06cdeae279d153f06ee41b1931db52"
    sha256 cellar: :any_skip_relocation, sonoma:         "f75f2d4285322b0ab8e4bbeea51828bd4d60b763a59410926a3a4debb8d758d3"
    sha256 cellar: :any_skip_relocation, ventura:        "80c13897b2f02861e512f635ab0904ae6f27b1a54cbe62384b2f86bbf0666194"
    sha256 cellar: :any_skip_relocation, monterey:       "224eda1d39262172973fbb035655f78456bbf9deb90fab4a8c5654a37b45004f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d75cc86f72d8b4f799a39c80051f67599611e66d5495f8658e947338de247d"
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
