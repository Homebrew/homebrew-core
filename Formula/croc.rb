class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v9.1.2.tar.gz"
  sha256 "f5dc5aa37cf179f86982080a067218d0fccf8fead9b5b25bc3f1f9181e82ab26"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2fbd1e855aa0db11ad57bad89ef648db020ecda5cb1332df3fdf1efadd1f834"
    sha256 cellar: :any_skip_relocation, big_sur:       "246264a225d5038ffea692edf9275a738358583172e2aec02e2e379c464af22e"
    sha256 cellar: :any_skip_relocation, catalina:      "023f9f4b15170760827731fb864d724526d0c5f32de95a9d91eb2866a32ad4e2"
    sha256 cellar: :any_skip_relocation, mojave:        "c84a3ec364c4ab9e161b0ceb8d2da35d546536e5c7d52d0d1305d88f8de4d0b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
