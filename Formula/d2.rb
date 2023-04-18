class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "abfc926a7dbb090c73012c8bf37558a8ae49d5c6045211b50a3386d8cd60b8dd"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73694adec77493fbfa475885204147c554adf728b450217721053f7b43bf9950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73694adec77493fbfa475885204147c554adf728b450217721053f7b43bf9950"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73694adec77493fbfa475885204147c554adf728b450217721053f7b43bf9950"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbf20963e2d42aadd31ab4c4a42983eb351c59651aa90477cabbd85e43d4a21"
    sha256 cellar: :any_skip_relocation, monterey:       "cbbf20963e2d42aadd31ab4c4a42983eb351c59651aa90477cabbd85e43d4a21"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbbf20963e2d42aadd31ab4c4a42983eb351c59651aa90477cabbd85e43d4a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767b9dcebe9aba53a501f748189e22305c82de48cf058369bcf564b52432dd62"
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
