class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "80d056c55cda794ce20b4f257bc77bd82aacf15962b7855d187098068a5be02c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dff8ed88ae9a9fa36a962b2c4b0d9ade63e0443b873dc9a168bbc0295120aad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea25a39f32f510c96dea8065524166538831d19a6b1ba4cee7d33216e6e1653b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe1a4f2124309669b554af3b26584f2d8714462c85428e61c5853010dc8e1cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "054aee1b31ee4396e3893c864c172acba32942683aa42e2402d2d4bdaf0311c3"
    sha256 cellar: :any_skip_relocation, ventura:        "1c6112be84262492c4a2172b55d69d198731b8cce0fa5931b7680b8ae7a9be42"
    sha256 cellar: :any_skip_relocation, monterey:       "0a50115a0b7ee3057ed8f0bf60ba4bc3188740d02b9546256cfe39e3a3e89cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c8bbd5eb2c40f20fab4fe1e7962ef83d487762ce8785b6af0d6bb5fafe03ad9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "commit", "-m", "Initial commit"
    system bin/"lucky_commit", "1010101"
    assert_equal "1010101", Utils.git_short_head
  end
end
