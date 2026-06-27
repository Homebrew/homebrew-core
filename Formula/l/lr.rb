class Lr < Formula
  desc "File list utility with features from ls(1), find(1), stat(1), and du(1)"
  homepage "https://github.com/leahneukirchen/lr"
  url "https://github.com/leahneukirchen/lr/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "c7c4a57169e1396f17a09b05b19456945c8bb5e55001c5a870b083c0b4a23cd8"
  license "MIT"
  head "https://github.com/leahneukirchen/lr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "167285f3fa15655f9e876fc9490f55c9a8020eaba6ac352d0a6a321813a7fddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2d40700048ac424d539d5e47de43a1d3104051960b31c5ea8432fca67c7f2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fe7cc6d4ed8e75f8ced5b053aacf5ab9fdf95d5b895d1ae1c5a61fa3b7ff973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fdc48b4a9838e4f6c9e6d11df5e34e36df89eb4941210ab788ab7deb10f221c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5230ca8371fdb46e61dbf67594c88c42e7c2ec6962b30d7f6e27210b59a3e269"
    sha256 cellar: :any_skip_relocation, ventura:       "36365773b66ab206bc98c3d915baab1fc3177e368c7e3cd7daa76fef0602f43d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47138d1f0cfdab17090ddeb7c6642dfed87ad578be30c7396c9969e193689035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7bf0e9c38ab1c0989106dcdad894777c9e6f0bdb6a8e939e394fd71a542d37"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match(/^\.\n(.*\n)?\.bazelrc\n/, shell_output("#{bin}/lr -1"))
  end
end
