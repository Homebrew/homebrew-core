class Displayplacer < Formula
  desc "Utility to configure multi-display resolutions and arrangements"
  homepage "https://github.com/jakehilborn/displayplacer"
  url "https://github.com/jakehilborn/displayplacer/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "54b239359dbf9dc9b3a25e41a372eafb1de6c3131fe7fed37da53da77189b600"
  license "MIT"
  head "https://github.com/jakehilborn/displayplacer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3130d189e26a7f30517372527c5b28c5c565ef87550944d865cf2bb4f6043cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "96332bcb8154d5fc6b7fa633fd81beefa075f13f54888285eadbedc7caf55cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff4162b800acb041980b63958fa60f763164bcd01dff7adee938c27e5604434d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38e7728cd446418f5a52e472d7a6f5dde45c54a52f73de6dc817504f9dc3461b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dbe6fc64a231b1a59367315c1d0e10c6ab46ffe7bdb4cd0bc4112489e627775"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae106ea0057e4eb35944a9d9c0f9b29c4b693022b09a15a67a809aa36aca5c30"
    sha256 cellar: :any_skip_relocation, ventura:        "95bf79968d24216d2d00c935ed8931e4fa4cac2ae338fdf29f0d55428b577247"
    sha256 cellar: :any_skip_relocation, monterey:       "08e1a9094bb445d6e279cae726122a345af8687f1d83f431793f3317a86b9131"
  end

  depends_on :macos

  def install
    system "make", "-C", "src"
    bin.install "src/displayplacer"
  end

  test do
    assert_match "Resolution:", shell_output("#{bin}/displayplacer list")
    assert_match version.to_s, shell_output("#{bin}/displayplacer --version")
  end
end
