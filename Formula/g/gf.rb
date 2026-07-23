class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "9bb1cac58cced9a8efe922f90401bffe05d5bb3f6f72917a617a292963a58e54"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bd043a15d4e3daa0dc5fda76ce8af489bead17458b195257a8e34e73218a44c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bd043a15d4e3daa0dc5fda76ce8af489bead17458b195257a8e34e73218a44c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd043a15d4e3daa0dc5fda76ce8af489bead17458b195257a8e34e73218a44c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7afc404b603d9a1fcaaa91f95f2c8ef3f05ab425ca8ecf285d130c60766f6219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98c47fcbcdd812973cce6b85bdda7227095f8c3522ca5f85fe245d1ff4443d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb83c114990b30f4215d08237e4ce5a296e1bd8b5fb39e4a10e80b19a5e6502"
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
