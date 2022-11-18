class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.11",
      revision: "225927b9a25f0d50ea63ea18bc7bb68e404c0cfd"
  license "MIT"
  head "https://github.com/zyedidia/micro.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "face927b474172b6460f02bda11ffeee76f4abe623193d08e21446be11cff983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38c0591d346653f2453d54d2f1a1eb4b38a5f6c252e0908b3f86b9969128bcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce9b212e2b846daebfff3621773936b2fc346f9cb3364adf7e8529930fe6735d"
    sha256 cellar: :any_skip_relocation, ventura:        "3af758aff2740f1322e3380a0bdf709646d6c487bffda0d1e10c3095187475be"
    sha256 cellar: :any_skip_relocation, monterey:       "6aaa311d1521194f4870b70d2b9d9a556a8094e7ea516ede0081ff347c92c8e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5c8c80a974e125c90c2b3ced8bafbaa4fd45317707a898f562ce4f9b50dd10c"
    sha256 cellar: :any_skip_relocation, catalina:       "fb5679cefda546660ece77b25b34d3ab948e899493e4d910a4f2c8c29e6e10b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e8dad268f3cd12cef547100efe87f2ca402fff61d0d1322c60b02dbd8823207"
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
