class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "10bba8b81bc6cf4dd7bdb3959dfa105d5111feb45a184be7b5860c826838d319"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40a48583aae6eec75f7b63228b8f9242b9e5bac4dc30be47a4ae0ba30e89a264"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a48583aae6eec75f7b63228b8f9242b9e5bac4dc30be47a4ae0ba30e89a264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40a48583aae6eec75f7b63228b8f9242b9e5bac4dc30be47a4ae0ba30e89a264"
    sha256 cellar: :any_skip_relocation, ventura:        "07caf9cb15001fbdc928ba460c8ef895ff735b0acacb232aabc60a14849e5494"
    sha256 cellar: :any_skip_relocation, monterey:       "07caf9cb15001fbdc928ba460c8ef895ff735b0acacb232aabc60a14849e5494"
    sha256 cellar: :any_skip_relocation, big_sur:        "07caf9cb15001fbdc928ba460c8ef895ff735b0acacb232aabc60a14849e5494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c5c4ff5b47d18979975cfd7443e36969f1e5ccb198dd7bbc2835437ddd4602"
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
