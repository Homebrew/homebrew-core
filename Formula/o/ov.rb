class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "fc582e832dd1b85c04ec0347454a56288d119a1eff76e2e7d63da34680b855a4"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4e0460d4041ff75791b38c95b305132b9ff0584ed79ccc55b17902476a1de4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e0460d4041ff75791b38c95b305132b9ff0584ed79ccc55b17902476a1de4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4e0460d4041ff75791b38c95b305132b9ff0584ed79ccc55b17902476a1de4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bf6bf0251b6fc0e11722f4bab2ba7177469ad9a91025080c4d7090fc7a52f20"
    sha256 cellar: :any_skip_relocation, ventura:       "8bf6bf0251b6fc0e11722f4bab2ba7177469ad9a91025080c4d7090fc7a52f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2979b74576b3a37bc49b328999ae34fe7b874789cd115fea90859a671bdf972"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
