class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.5.3.tar.gz"
  sha256 "38c418e8abe1bf6835f1b16d02c03677075af6b10ad4723392540ec79797520e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2cb6c0f8ff0b15523d749310f396b8acfa5256045b70d3937264e2e7ca52af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1358c3208d9954397f95e01a51bdb0f0fdaec323b87e0234c4c9f163ba3272b2"
    sha256 cellar: :any_skip_relocation, monterey:       "1648459e3cffa908a42cf13b57da3060c684ef6bfae14f9d6087fac5f47f043e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f75b57be1ca89317612bae27a96211f04f00ad49f5dbb215dbecafb2a95ebe5b"
    sha256 cellar: :any_skip_relocation, catalina:       "af15aad5d8b43548d0492384ba95ad630377bad0597d4a83d38662342eb4b3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80646f51a6a6aecb4c4fcad00b451f8781cc5412af90fcb3d9abcd14402ee16c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
