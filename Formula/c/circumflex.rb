class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.6.tar.gz"
  sha256 "bd041bd5fa1abc968775debf6a6052a5df6d3d2ec787be0dd8aea9c6b1e0af9d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99f53a00b74fe47068dbd40408e010a2019c05a9ee613802d090ad6639754813"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07b67bf98ca649b9311c4d222ec13b1615b2ae03465134232e543e577cae443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950664bfba70d00f902b90ab9d3ded7ccbeb3f0a1e26eb3d762aa17f8a2c34a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c08ddfdfe1d2a6c84467f2802f48b5ae49f504c89d536920ebc6477b4757066"
    sha256 cellar: :any_skip_relocation, ventura:        "43a95599177dcc5e07e01f663780ae67027301b1727d5a9dc1c732e113e33e8b"
    sha256 cellar: :any_skip_relocation, monterey:       "cf46892911c877e2bca47b13f786d16538f1b500dfafeabccf8bbd4850339c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35ad0a7ef94304d0d98da635684f7c1eb3414f32dd9acac50f866f2134baffdf"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx article 1")
  end
end
