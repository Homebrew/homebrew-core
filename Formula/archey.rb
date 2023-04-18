class Archey < Formula
  desc "Graphical system information display for macOS"
  homepage "https://obihann.github.io/archey-osx/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/obihann/archey-osx.git", branch: "master"

  stable do
    url "https://github.com/obihann/archey-osx/archive/1.6.0.tar.gz"
    sha256 "0f0ffcf8c5f07610b98f0351dcb38bb8419001f40906d5dc4bfd28ef12dbd0f8"

    # Fix double percent sign in battery output
    patch do
      url "https://github.com/obihann/archey-osx/commit/cd125547d0936f066b64616553269bf647348e53.patch?full_index=1"
      sha256 "a8039ace9b282bcce7b63b2d5ef2a3faf19a9826c0eb92cccbea0ce723907fbf"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "652777f045fb4491d98b7c27b28d05b84ef1184fa0216ca9428ba0ac172baff2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f34208326a88d41a2da5abefe270f45294f40b35982f6dfb86c5b908fa447837"
    sha256 cellar: :any_skip_relocation, monterey:       "72bf6698b463589cb2a2575dd4fb75f5ea0f0aab579300e7912a7cc1a8e445bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "909d885f7b4b146ba77be86f58edb4e98fceb41e41dce9447490a2ab0a08410c"
    sha256 cellar: :any_skip_relocation, catalina:       "909d885f7b4b146ba77be86f58edb4e98fceb41e41dce9447490a2ab0a08410c"
    sha256 cellar: :any_skip_relocation, mojave:         "909d885f7b4b146ba77be86f58edb4e98fceb41e41dce9447490a2ab0a08410c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34208326a88d41a2da5abefe270f45294f40b35982f6dfb86c5b908fa447837"
  end

  disable! date: "2022-07-31", because: :repo_archived

  depends_on :macos

  conflicts_with "archey4", because: "both install `archey` binaries"

  def install
    bin.install "bin/archey"
  end

  test do
    assert_match "Archey OS X 1", shell_output("#{bin}/archey --help")
  end
end
