class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "b784d6472d53fdaaa7ecc9bdbe23456e2b4a90e18736828028b3f951537e56a1"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61a38ce31638ad307378e0031fce216fbf8e5082132ac4866ab5ca81e7337010"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a82ceeada44a2e61646f59f749286ee4347ca364fe568007235089844fe473f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a82ceeada44a2e61646f59f749286ee4347ca364fe568007235089844fe473f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a82ceeada44a2e61646f59f749286ee4347ca364fe568007235089844fe473f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfca943125fe7319b8bd9a09256b9e62a6185d378b2394c307273a488567616e"
    sha256 cellar: :any_skip_relocation, ventura:       "cfca943125fe7319b8bd9a09256b9e62a6185d378b2394c307273a488567616e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06d2bb3e6e93b2734ef66111772aefb0120938dabfb2697dad37e119e09f0157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e100511019db1329966018c384c0be60853e9e2bb5de50e8d4b092da92552a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_path_exists testpath/"test.svg"

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
