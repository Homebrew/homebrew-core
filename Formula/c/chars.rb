class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/boinkor-net/chars/"
  url "https://github.com/boinkor-net/chars/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2f79843a3b1173870b41ebce491a54812b13a44090d0ae30a6f572caa91f0736"
  license "MIT"
  head "https://github.com/boinkor-net/chars.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2f8ce443f25310a09c925063e8900fa1385d6bc02501595f7b47d92d813a7031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "217f90ce26ac0d657e7ff5fc13bb07fa945453e9877adbf436af02380e65c8a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d2b320036c7ea379db3cee9a29ed6b5c55441c7ad984c14d7942d4949069e2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec2d1f5493c3b1f8a47bda9daf15bef446399aebac55becc11a01248248b9f4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba84b41f4ab585ec74835948f68e71c3588745dd6f8a748484a7a76e6ae45272"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6953f523530f24505bd9d08be048287eba3f2caf1e766fdab8d7bda2891d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "239b19d1fd2b822b711d04eb752572145d1d4c310b4235ac4d18ba9de08af71f"
    sha256 cellar: :any_skip_relocation, ventura:        "68c80f7eecac24a7730af591f936abe6e7d5c4189710c9da22afe81e967f4b98"
    sha256 cellar: :any_skip_relocation, monterey:       "65532ff891fc1197305aee0b466e0bd7fdeec5f5aec9c6559449e7255949c12a"
    sha256 cellar: :any_skip_relocation, big_sur:        "eedb2d02f6e1f3889cb6db4d5769b99b7be2bd7441872b7c6e9861c2582a482e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1f63205aa2f88bd033b5cf88619caf0d457c4dff156eae6ee5ac433775dbc1bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3b72700c113acb7f3fbf7b977d2e2b16906384325d0f606ada0929c2eab9a9"
  end

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match "Control character", output
    assert_match "FS", output
    assert_match "File Separator", output
  end
end
