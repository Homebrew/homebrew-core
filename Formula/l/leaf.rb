class Leaf < Formula
  desc "General purpose reloader for all projects"
  homepage "https://pkg.go.dev/github.com/vrongmeal/leaf"
  url "https://github.com/vrongmeal/leaf/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "00ba86c1670e4a547d6f584350d41d174452d0679be25828e7835a8da1fe100a"
  license "MIT"
  head "https://github.com/vrongmeal/leaf.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8cbde0f8834319b4253a75e409376afb5e5737fea3a54e8318e76c318fe92ead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "09207a280786c059e1101f26dd85aab2ae159a8f295de090825959f88671e165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ac38180d691799c039e350fe1a9b3f6231b55bb7e3081495709c07cd69a3d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bd1b00e0418f45e3d96f7f2bfab43c68dda0d3f667335c64f4427bc6dad12ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bb7a962b8708d9d607dcff6ed3dba9e485a0963164608662bfcf70e84ad1d5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7880e0f8658071b6040d8e32161e77ef72b6bf7b96489443acfa6b9852af31a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ddc73292bbcf5bc74b2d18739cdd64310ffcd86b3e6d7a3110558bff462dce1"
    sha256 cellar: :any_skip_relocation, ventura:        "310126fc24bf1b5141c5b17ea0e824fc9a424d61f0b80dbcafccfc2adb3eeb27"
    sha256 cellar: :any_skip_relocation, monterey:       "6f6e8b0d0775041da2e114e277d6f4790ae4e2b72b1ed409398bc39507b437f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "395fbe11a4e482bf227e460f239ee008f2f6b50e9d071699c703c87d452b8ec0"
    sha256 cellar: :any_skip_relocation, catalina:       "995eb379b3e25e45108bd3c2166baef1fcd6f6ede329572133b8b203261ff9fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "08577fa38b639cca561b8f84c89d5ea82b8d2f780d07910dcfd008c358512217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84a9c0400bd35d736290ce97440f83c844e728b0b79ab95c2b9f88446b2b127"
  end

  depends_on "go" => :build

  conflicts_with "leaf-proxy", because: "both install `leaf` binaries"

  def install
    system "go", "build", *std_go_args, "./cmd/leaf/main.go"
  end

  test do
    (testpath/"a").write "foo"
    fork do
      exec bin/"leaf", "-f", "+ a", "-x", "cp a b"
    end
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
    (testpath/"a").append_lines "bar"
    sleep 1

    assert_equal (testpath/"a").read, (testpath/"b").read
  end
end
