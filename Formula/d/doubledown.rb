class Doubledown < Formula
  desc "Sync local changes to a remote directory"
  homepage "https://github.com/devstructure/doubledown"
  url "https://github.com/devstructure/doubledown/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "47ff56b6197c5302a29ae4a373663229d3b396fd54d132adbf9f499172caeb71"
  license "BSD-2-Clause"
  head "https://github.com/devstructure/doubledown.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7e93ea6b6323a89639c314a3f44364e2aa3ab4e5d7017d6b352c8761e5f13fa5"
  end

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    system bin/"doubledown", "--help"
  end
end
