class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/refs/tags/0.4.0.tar.gz"
  sha256 "81b21acae83c144f10d9eea05a0b89f0dcdfa694c3760c2a25bd4eab72a2a3b9"
  license "MIT"
  revision 1
  head "https://github.com/technosophos/dashing.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "78209eefb9ac2ea5604da56e5128386f4f14f0e520377a1ec2a3541eebe452de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "44a8c08c0183e0bd8a4981e81213332334e5c818a26008c90ca6bf6a5895f206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aba051824c3bbf06b791ce36a5362d6c7b10becfe692c91dcc3b784d275565f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6afd8514bfadafabffcf92070f6daf79070d39d0cfa6f246c0baf83720f1632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "068ec0d62e2f599509d34a2d366895dce2464eaa9aa1939a553dd1e31c8238d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72b9d5ea8aaf171f9a46e099f190a9adf9ad90b6bd90dcdc54eaa922e2c277f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab329a945ab070afaf9b8b6b210b207b823e4a929922766029c281ae630c7079"
    sha256 cellar: :any_skip_relocation, ventura:        "304de6dcdcc89d4f94952b0b1d547a6e77abdd355c2825ba3260057c289c26e5"
    sha256 cellar: :any_skip_relocation, monterey:       "a0c325204c959b5956248606f6b7fcb4437c6dfa2c75f739d4624fb912ecaa55"
    sha256 cellar: :any_skip_relocation, big_sur:        "7297bb9c8b50feeda73af51b59acfcac18f9d2beb57738de293146aaca7cd089"
    sha256 cellar: :any_skip_relocation, catalina:       "43702cf1fbdeb449e9205716635cba4c62449e575f9a6ab45eeb4aeb166fdf9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6ac970aad0a46e0f50606334b2218aa1b2103347300e59e01fc2cc942580e7d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982d82dc58980aa81fadf686557c5c075ddb95b9ef0f8456e7b32b6ed49aa382"
  end

  depends_on "go" => :build

  resource "redux_saga_docs_tarball" do
    url "https://github.com/dmitrytut/redux-saga-docset/archive/7df9e3070934c0f4b92d66d2165312bf78ecd6a0.tar.gz"
    sha256 "08e5cc1fc0776fd60492ae90961031b1419ea6ed02e2c2d9db2ede67d9d67852"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    # Make sure that dashing creates its settings file and then builds an actual
    # docset for Dash
    testpath.install resource("redux_saga_docs_tarball")
    innerpath = testpath
    system bin/"dashing", "create"
    assert_path_exists innerpath/"dashing.json"
    system bin/"dashing", "build", "."
    innerpath /= "dashing.docset/Contents"
    assert_path_exists innerpath/"Info.plist"
    innerpath /= "Resources"
    assert_path_exists innerpath/"docSet.dsidx"
    innerpath /= "Documents"
    assert_path_exists innerpath/"README.md"
    innerpath /= "docs"
    assert_path_exists innerpath/"index.html"
    innerpath /= "introduction"
    assert_path_exists innerpath/"SagaBackground.html"
  end
end
