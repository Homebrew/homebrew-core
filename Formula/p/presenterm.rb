class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "18a50e61c1a90928f6e0ce9f72bcfb8a2be76b2d220663830cf9a607ecd68386"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9428716f30ece91baa9dff6280be4c54f0eb8ceb8e08692ec0cd538df44968d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41408cc1581c0d36d4f0be98ddd41605ec257c3f4fd01b5a78fa895e72aeb144"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5c802de2d1e83438664fc1363053d587bdc15aa7ed39ac56025f4d00d131357"
    sha256 cellar: :any_skip_relocation, sonoma:        "187acb5df813157c843c2ec49685d404c7d6b30f65d2f770ee9615e5e1e714e8"
    sha256 cellar: :any_skip_relocation, ventura:       "07dc30e32fec87cf558d9cb56353e30d908a2bee7859aff74ac3cef63ec9f584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e420f9ca21ad201913fb7f7e418c5a8fd9158e6418bd2f8878a2c8d44d3dfd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257b87be0c02044715ac508726cc3802865fbed2427a3bd48f307502912f9145"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
