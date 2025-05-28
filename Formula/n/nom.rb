class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "3d8482a73b86605d02990063122b15b4573cee503a6140745343c400a7f21411"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f383c6c4eaa2afae887f8a88927fcdd22c6a33120918b0e87c88834b14c5c3b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37cf55fd78add7c76e2be015e8a593a36764ab3b52eac9dfca9fd3c87fdb381"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9d3b9e5e7fd80283bdf6dd69c2f721c709ba303b246e3943d65ea3304694a85"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df7dc88c7267c12c74d4967e9e73d2169f50c789c708e518c02a21f2537fab4"
    sha256 cellar: :any_skip_relocation, ventura:       "a078020e1f1ea3141b8fa4bf457a1a1b6fe27745f8aa441b1a24ef3fa28efb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6076b8e040c1376343ca2ece6668d0bbdc6622b517453789a882c0ca25bb6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd3b213779f2438fa5b68568d1e5e228ed48c350538d5d604084faa4359b0f4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
