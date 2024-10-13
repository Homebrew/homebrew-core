class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "2e66d0012202070dccda6b8fdd8f13cbbf316e23d97fa94327908e4e87b685e5"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4e1c0736cad71fe3a606a3c9f8a0995a450f63180258cdc1709f15d74e754f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4e1c0736cad71fe3a606a3c9f8a0995a450f63180258cdc1709f15d74e754f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c4e1c0736cad71fe3a606a3c9f8a0995a450f63180258cdc1709f15d74e754f"
    sha256 cellar: :any_skip_relocation, sonoma:        "59498cd5019df052264e524cc6b34a70ffdf89faf6ff2bb1ed759c5a2680c509"
    sha256 cellar: :any_skip_relocation, ventura:       "59498cd5019df052264e524cc6b34a70ffdf89faf6ff2bb1ed759c5a2680c509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a265f42290d383fc9a88106dd1914c4bd6dfd92b6f9cbbe2db96091119274fb3"
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
