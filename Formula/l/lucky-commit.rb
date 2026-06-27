class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "cab69b87afac8b2e8db3949397695809977199ccc4894b8af53e59da7f917126"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07d58a7fd30317d98c7d3ee2a5b78afe8b274b6272ec68dbb12a519c04c71eca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c93d4a4678944faa2b8d4a7144081fbb2e58cb2fd90a9738f955f257ad604d1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df456578bbb007849607cecb96e916bc4df5201846a2ea5b57cc6cf033c0250"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eabaed3df8acebb03dfc099f24ab40d7a070346c5b9d926bb9a4cf8afca6987b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cad169a029b5a10886af7b82d32f3a353df1ffdb4c253feff12fb99ed3efcbf"
    sha256 cellar: :any_skip_relocation, ventura:       "ddc33a6a32fa743b4a6137716900a09736fa291bbdff36799637050d625e06d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f1b4db17c27f0b29b0aa25395e3849f2869ad538371a813c695b794a4dc4257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e04671feeb1d045a3eb1ddc47ff6f4b765b0f5f4512b6e975a3bb8be79de6a"
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
