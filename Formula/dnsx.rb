class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.9.tar.gz"
  sha256 "0c47c3eac48142548064cf983393c2825556f736c35c708e937835af73b7de96"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d516a9861eae253ec6b00a18a81e69156c35c57eca3dba65623fd1f3a37861"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b78bb6c44dcd57efeb975339085c806d2cc91b53beae7312234756f5139fdf08"
    sha256 cellar: :any_skip_relocation, monterey:       "01f2a3207a61904dcfe7274363da9c5644ad8e3d369d7ac09de60bd1a885d324"
    sha256 cellar: :any_skip_relocation, big_sur:        "c188d3d8a05ee91a8a7583c06bb3c198d68d977a922eeb295852b1f5176ddd7a"
    sha256 cellar: :any_skip_relocation, catalina:       "c4776c1f20a7de10c6f0d5df9ef6452b955ead986225528864e43eac5adca0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca953420a58a24d734809542227473ccb145471f49c439e62b805950dac7d9c"
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
