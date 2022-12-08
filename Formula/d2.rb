class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "78fac0235fd583e28d961b0fd066994095a9cec4d5a834747833bbab042ab1c0"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50d3a28e005504e7cb9a0dc0eb7aa7876544dc6a20926a5d1b459e2c386253a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de7adefa582c3501a14a3ab93cc46bbd040a3bde81721826b41ac9a5d361f7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1b19778e3f7703683de8e6e30d60b4e666a93fd66450fce2dbf5a455c5420ce"
    sha256 cellar: :any_skip_relocation, ventura:        "5339fcccc5372faadcb1870a4ebb011fe1f318575735d1993c03d85295677bd8"
    sha256 cellar: :any_skip_relocation, monterey:       "6279afe99ad12bc8dc9c0e93c973eb02f34dde67725edbc39f1382e54c7ce68a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff1213fa4742636b3c1e80c82f87278eb4d86d30019efff38c0ec5ce7d0aca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9706aca80e395bfb404e7910d596820a213bddc79de62d17980b08c2fad9cff4"
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
