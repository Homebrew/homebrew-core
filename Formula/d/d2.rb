class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "ddb6210b927e62c0111cb9a9f7320010df8b89bf6a24f73d6012f6d4e477f27c"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18eec53b0ff4c8f1d497f3ade4fb74cf90cb8cf1b964d7780575f1b66372058a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18eec53b0ff4c8f1d497f3ade4fb74cf90cb8cf1b964d7780575f1b66372058a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18eec53b0ff4c8f1d497f3ade4fb74cf90cb8cf1b964d7780575f1b66372058a"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d495e684780ba3ed3d25d9fdf15c1b2822513aa9ed79789579b1fd2d1b8d81"
    sha256 cellar: :any_skip_relocation, ventura:       "08d495e684780ba3ed3d25d9fdf15c1b2822513aa9ed79789579b1fd2d1b8d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0218d042f1f402ae15f70f18735a05aee27c20cef0c4808b7fcca141a2c64e6"
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
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end
