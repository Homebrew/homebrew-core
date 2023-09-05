class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "12",
      revision: "baaeb1a5cc24c82af732de468aeed61cc41bafe6"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2423c8416f487e0e40d40480e5b72793ba6cb785319697b0af5b2514a8556b78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2104e4ae913da3c966aa0a0dfdf33ca9b577cad677a4eef1d91b89abfbf5a946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2382b8577664a05b5c4f5e0dd6dba028cd7d0b6d645529edb18002c2c4db6440"
    sha256 cellar: :any_skip_relocation, ventura:        "35657c62d6b0c90970e81938713b56d184b63bb763f99d0df6cec585ce29eded"
    sha256 cellar: :any_skip_relocation, monterey:       "41c48e0fb85dae26495d8fa77df66141c8c9fc57351bf226042ae4a741fa9f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1043dd5a4f3f974a78378c74ed1102e29c3047fe5e73c0404e5ee80dbf3e84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63609ed2bbdce05d357d045a39c8c40b6b0be353f0b1c82ecebabb6ec8d297b3"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
