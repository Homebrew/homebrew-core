class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "e7df127e20ec37c83c881e15c6fb3fbefb55cbfeeb9380a78575164726144bd9"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fe73ebb390941c620177e27cabc4b8e53f93bb0c7235c68e7ffaa2d0a46ecc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1efbe689cf17735288ea51d9081773c561b56b0d13de28e82697e427a7a327c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a7ae2ab809333166533e2f4a8011ffc5c231e01c521353f283d01b3d8b45908"
    sha256 cellar: :any_skip_relocation, sonoma:         "b843d5a5fb1f69c9f98fefd3e10730069230457914480ba61f3d7c091856d067"
    sha256 cellar: :any_skip_relocation, ventura:        "a24e70b809153b120cae373865d485632632fced7cc027ecf60fd3859903085b"
    sha256 cellar: :any_skip_relocation, monterey:       "3d119d85ed9816db269acba29acd07557cb8d991a95d125fd240cf5a85c074ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e0665995664f122041fffdd4ba4f1c30ba8ea5c15f7aa7cc0c6aaeb405160f"
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
