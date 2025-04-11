class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.46.tar.gz"
  sha256 "829659158f0dc4f079105b4d35e090045420ec678ee5946a60885c698703255a"
  license "BSD-2-Clause"
  head "https://github.com/mmarkdown/mmark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262640ffecbc9ef0162b833564471b356178a90a941c31f1a22f1843ab9dd4fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262640ffecbc9ef0162b833564471b356178a90a941c31f1a22f1843ab9dd4fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "262640ffecbc9ef0162b833564471b356178a90a941c31f1a22f1843ab9dd4fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fea4feca2a305de18c36ecfefd1b8d33b77bbba4ab2f5ea96ca5bf53991a6aa"
    sha256 cellar: :any_skip_relocation, ventura:       "3fea4feca2a305de18c36ecfefd1b8d33b77bbba4ab2f5ea96ca5bf53991a6aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "194e0b3e6f02124ecde4c25462131623cc3304d211610358501be2c9e868d46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "310b97f3f8e757e84390f318b426679ab91af7beb1f4444c3b7d27592d32289c"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
