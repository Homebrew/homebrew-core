class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "48652d8016f9584840783cd7a98f0023134e9e38ec948207271d7f7dbc478f05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9409afd283e5b2003020c3c1ba4835800ed6aeac9086caea545fee380e55514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c446995ddbb07b918dc1f5740b829fe8a8144a99a5a9202f2d56bfd6a5fecd36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e16c7e01ed3ee28ba540cac685fa5841431c3baebbf966a14e4c9ce01c9a04ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "eadab6dbb7ff27594d7e7f91477d00362807694120914b1f795143c25805d317"
    sha256 cellar: :any_skip_relocation, ventura:       "4b801b069b937283e115c280e9fba092a45aaaa4412bbb278925900756813b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "815cf77c9bad189cbbc7db3c20c8004bf34295cfcea87eaf639c44f2e1f73cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45322d43c334601cd776812b1b3269f6e3ff7cf28f43ca354f199d9e607f9ebc"
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
