class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "5a7fb24f2116ff63f7350c60933134a80d93f0e4f298f7d2b654e2e3ee58378a"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98839bed0f0b1cb604efacb61fe9fe2eed06fa8c21bf54e8c40b381c5122cad3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98839bed0f0b1cb604efacb61fe9fe2eed06fa8c21bf54e8c40b381c5122cad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98839bed0f0b1cb604efacb61fe9fe2eed06fa8c21bf54e8c40b381c5122cad3"
    sha256 cellar: :any_skip_relocation, ventura:        "7985f08bbfc255a9f6dddcfc3b6a66068433f68da0abdad54cdaf291b0cec536"
    sha256 cellar: :any_skip_relocation, monterey:       "7985f08bbfc255a9f6dddcfc3b6a66068433f68da0abdad54cdaf291b0cec536"
    sha256 cellar: :any_skip_relocation, big_sur:        "7985f08bbfc255a9f6dddcfc3b6a66068433f68da0abdad54cdaf291b0cec536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa843ac3c34cc1433b410ba782d027b889f9ddc8d134ad2d92cf15112cd7bc0"
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
