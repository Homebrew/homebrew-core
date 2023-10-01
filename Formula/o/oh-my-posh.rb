class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.10.1.tar.gz"
  sha256 "10a5bb05b0c949746a63a2ff61be2cbf10799feb38f737bf7376f63a55c4f73b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d50ba309cd56ac261c54f00431693ff0e45ea8294391154308e23c48a80dd03a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98e37c228efd1279f16031f106577920a38fa8fca6ee3c66fa0f4f3aa51bdcdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4d1a4ae920c8bc47f374eaeb27587c1f4be0087c31ae63ef4b1ef0cab23f4e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f486935d593be48dca396c401138118127c338de1c9ddf90075737bc0b410f"
    sha256 cellar: :any_skip_relocation, sonoma:         "307ec7bf380e7a0318f8d61f8db096780ae9a43d38e433e6468ba8c1b34ede23"
    sha256 cellar: :any_skip_relocation, ventura:        "6954ac2ea20a5c6a6fdddd344d06f5644b32305fed5c031c03796eb88577c8a5"
    sha256 cellar: :any_skip_relocation, monterey:       "7dbd0448ea402d1d344e88c937152c099246160100bd9a006ba8783477df6c61"
    sha256 cellar: :any_skip_relocation, big_sur:        "04aad61a8db669b2902463789c5965e4eb23dd629a60f0756c6d77cc8001cc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7fd8a70317cc7f88046acbefb4fa225d0a9be41009ac809fe49156bcd4722a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
