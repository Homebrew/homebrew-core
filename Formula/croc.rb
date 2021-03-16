class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.11.tar.gz"
  sha256 "31df18c9fc38a26aeeab0d12e57f34feba602a3ce6f4a5a0474b46a50df3b459"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec453723cf4bc4fdf9c9f6606dd2502f7c89183214b83a9c18f124942469c7c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fa9c99807dc5335912f64a46e97ba0f24ecccf6465e3d38e7a64b611f922c19"
    sha256 cellar: :any_skip_relocation, catalina:      "cb6d5a3123e92271008d0e56d381b264590d894b1565400cb7f59ce6f68a4721"
    sha256 cellar: :any_skip_relocation, mojave:        "99b580330fc4668b1d47a5e38cf84bcd1f890886400cbde6aebe1a6b983fe0d8"
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
