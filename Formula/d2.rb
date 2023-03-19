class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "1f58a1aa1fb3d54fd95afe6c737368c861f794f59c8e38707f98a5c39f093625"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62eb0e5b01275ca8a2ecd2a11f1dc855a807ea75bc10622a35f607e7436b919b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62eb0e5b01275ca8a2ecd2a11f1dc855a807ea75bc10622a35f607e7436b919b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62eb0e5b01275ca8a2ecd2a11f1dc855a807ea75bc10622a35f607e7436b919b"
    sha256 cellar: :any_skip_relocation, ventura:        "973ddcf2d29d509016d9b8c602dd5a76d9f77c9c0050eedf65d0e9a200e823d6"
    sha256 cellar: :any_skip_relocation, monterey:       "973ddcf2d29d509016d9b8c602dd5a76d9f77c9c0050eedf65d0e9a200e823d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "973ddcf2d29d509016d9b8c602dd5a76d9f77c9c0050eedf65d0e9a200e823d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4b1a41aff3c95773f663d46217d89e54eabb7eb8a18e892dc4561f5066fd95"
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

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
