class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "3a45ef0e3bdf4ce6fc72fca6ed34c45c17a6ccd61e0b22adf658cf3abb2341cd"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4633eb98d0d6f053e5cc7ec0892aec95b1f5dd992fa0fea4517c39187314ec81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c6a9c8f13820ea2479ae831c6b87a28c379e67da9d0b51f3db1b5787fa0b414"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "987225e4c304ab722aa114256b560c65a349f8cfd77e19cfd299b9ea316c33e9"
    sha256 cellar: :any_skip_relocation, ventura:        "63febc04a5a7282de128999e471e7d0e4d4ce3cc3391e50c26bf6d5870055032"
    sha256 cellar: :any_skip_relocation, monterey:       "71189bbc079fff657c67cd5959c81f6208c4ddf8a75904b25acbb5a492e557d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf348bbb21c1049f7706e7a0a2ff25282e0400beec8c6bf26e2a4c9db4026cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0da04604ed25e6c8792abfc90e13d50dac5a6ddde5c06e3c2c8bcab4e5917005"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", test_file
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
