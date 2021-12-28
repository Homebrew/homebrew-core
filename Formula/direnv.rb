class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.30.2.tar.gz"
  sha256 "a2ee14ebdbd9274ba8bf0896eeb94e98947a056611058dedd4dbb43167e076f3"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0ad86c8187d9e9ba856a44b6400e32d9dbd5dfe5ee33057fe03360a6b7203a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "150106b60dc418f81022bbc72f31bf0cebe1cbb5545834ded2a60aa7df86b61d"
    sha256 cellar: :any_skip_relocation, monterey:       "6f94b89d32f6cb1ad05137206d26b4928f7805e38a6bb6f6b9a73378b84c4e6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "98bb7de7a20b1f5d2959cdbda620840b7327eb42431ee2846f3da433826ffa69"
    sha256 cellar: :any_skip_relocation, catalina:       "8aa5afe8ff4eff8cac457ddcbd0e8342af70594ce588c5bdb5281a48e66159af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b9933c6b42ee0b35a69ebb9c26487270be42def0d534aeff66a03208152c882"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
