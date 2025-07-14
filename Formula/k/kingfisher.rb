class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "e2f70384ebb0bf61de20190504a6d05f9c32e9bf1d63ae1a14679629b9da81d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191e6025706b39182a55645d13b29329a0ad0752ae9240b2896ddb45436d976f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e29a2fc95ed425bb82e87ec18fc8259383cd205a7e9d76bbe64344221de60d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "763ab8c4fdaa42e157cff02d3d73db0bc9cb8cef5d2a6ad13d1ad1225b063093"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c780d1d31a730965c970197c84a2d5d3b6cbb349a4c9e6758c8e222715f015"
    sha256 cellar: :any_skip_relocation, ventura:       "aaa2b19bc37cccee81967d7e17cc074902c6293233ea4364adff0c371d5c0f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7a39a093630fa43f75499a5346e7116ecc2c606e42628eedd9dd75c0994869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "561de86b404474173687ae1cc2b2548ed718cfa4f1bcf117650df1c4b64ea3eb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output(bin/"kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
