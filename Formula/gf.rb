class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "65ab653225e3a6eaa8c690e9980835e41d7e0b537668444b0f7bf102aa30e782"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "642396743dd513429ed18ee234cc8cd6573cfd3cabff6df095f1750fa793360a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8817f5ab8027103f6d0f3ba61eeef5971d77d58aa6519b6f982036c90fb5d50e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f83d7284c9794aa8a0ba00edecc6df726caa691069e8bc25b64ca8c8da1746d4"
    sha256 cellar: :any_skip_relocation, ventura:        "feba5e63678b0b3fbac7fbf0bf4982f7cd61eb27a297b3dfbebef944cbd37329"
    sha256 cellar: :any_skip_relocation, monterey:       "a684e5e2eb730a651190401f377f490f5e7ce5b27e02a782cecccfab14aac020"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb34d3c79562a51f44e3b79d328f438a1a41d924fb323d3442491677d2333953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06bcbb3065158a6beec554fc29adb848ee961a51d60677c7d26a0cc3e5d9bd1e"
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
