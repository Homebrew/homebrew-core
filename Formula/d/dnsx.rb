class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.4.tar.gz"
  sha256 "7c0868cb27f904ab8e158881cf4862a15f216122a43525d2ea93a1aa7bf03cff"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57b464f2055562fba380e2e127b8a452799f59ea7b3d987e2ef44d4a05bf0f19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b464f2055562fba380e2e127b8a452799f59ea7b3d987e2ef44d4a05bf0f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57b464f2055562fba380e2e127b8a452799f59ea7b3d987e2ef44d4a05bf0f19"
    sha256 cellar: :any_skip_relocation, ventura:        "da7225bb684733cde3df29a1ad50837232077d96ec875c1773baf604867ea0dc"
    sha256 cellar: :any_skip_relocation, monterey:       "da7225bb684733cde3df29a1ad50837232077d96ec875c1773baf604867ea0dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "da7225bb684733cde3df29a1ad50837232077d96ec875c1773baf604867ea0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daae374e31add2864ab87ef6cd56ab7e21bce9224ec7beda56515a8844e5a429"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
