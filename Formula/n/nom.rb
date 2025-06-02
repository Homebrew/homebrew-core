class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "989a53d3ffb3fe3a2911c388c8672430f9b21d6f2ac2a9d2a1459c93b41b84f2"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1372bfce7a7b6e65883c92500d9ee3071fac6a025d7cc65213bee19886eb564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b6a34e8cd7a26098e41e2513bebf0171756cd82c808982611ec715b6d572cfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4000e9e3ee06568c113b4d1c87e8548fdee3e6d25ca9b76fd35299ede8fdd2ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd4b5f9ba47f0a20d09b2e93326a29ed1136b88478d59a8fa0fe99ea7c7b9d16"
    sha256 cellar: :any_skip_relocation, ventura:       "86241a50c67b4fc93934b83bf08c756d0d3510420afbb011780ae4d89588bf45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa5e124724b3087179f3985397d35bb572faa97371c223b9fab22afa4a10458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c29b33c35f6bfec07f3572ddccdb8b9b692ecd2149a4e0fe3fd199a326afad10"
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
