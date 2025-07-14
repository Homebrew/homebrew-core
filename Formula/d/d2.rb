class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "6e7e7c787755e61fc048cc0c2e939a330a3dad98ee0f3c1cd706f2c192416554"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b263fd0a4c819aff3cf1f45401208ca46d0e0b9702de97565051ce7dca60162f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b263fd0a4c819aff3cf1f45401208ca46d0e0b9702de97565051ce7dca60162f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b263fd0a4c819aff3cf1f45401208ca46d0e0b9702de97565051ce7dca60162f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bd702fe40271a6413415a26344a5f9386c62a12395f982c90f651a96cdaf4ce"
    sha256 cellar: :any_skip_relocation, ventura:       "0bd702fe40271a6413415a26344a5f9386c62a12395f982c90f651a96cdaf4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4c5b7a9948a73d481f89c3606abe5f10fe93522f937d12275862c9ff51baee"
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
