class Doubledown < Formula
  desc "Sync local changes to a remote directory"
  homepage "https://github.com/devstructure/doubledown"
  url "https://github.com/devstructure/doubledown/archive/v0.0.2.tar.gz"
  sha256 "47ff56b6197c5302a29ae4a373663229d3b396fd54d132adbf9f499172caeb71"
  license "BSD-2-Clause"
  head "https://github.com/devstructure/doubledown.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78f3d65bdfb3d5184fc3a10c8b161e9e41a4d14715c284d2a179ebf5fbe52209"
  end

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["man/man1/*.1"]
  end

  test do
    system "#{bin}/doubledown", "--help"
  end
end
