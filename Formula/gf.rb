class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "973c0582b933f9dc575aeff8ef93fb78dfa8e0c8179c9bff247f8051c0abc133"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84419c7e39efa8c0bdef6d7be36eef6981aeaa4179a78ac0b69a548df452d832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ed48fa2aca387594f93061d60f14a1eb2f182ee5a21adb86413eaa16ddf9dd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb66bccd7bb54efcf11dcb7adb1c93bb11da87d9ee9e58fb732ab2783c8cac1e"
    sha256 cellar: :any_skip_relocation, ventura:        "fd5968ee211472e1b8b94aa8bc99541003644416790db4a84a64d6fac6700acf"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc42f224b8762f5da8e6308119dfcba855585f481baeb9c0e214d2f2063bc8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "95fa1e631dd49723a69f25c38a44834550a419b5037d1ba8717f4e02bd49f3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb5568ad408f2dbe307a65a990b861513b3e077d004e526bf67798f9ff5ecad"
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
