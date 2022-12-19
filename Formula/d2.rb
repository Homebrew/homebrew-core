class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "5aeeca3dcdc417b1756b6e92cbdbf8dd61214b880d2bf8586b6da5230338b091"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f4d2f492b8756315df5411e1a31e155a511bc967ba47b76296a424e6ce5c3cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "773ddac5612e05f1104a10896ee0d040b792d8f7d5a327ea7eefeb096f6585f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7280996846e8ed5f6c252ab7fb5aa7c8bce245c70f77c2a03c51700a115b8c0f"
    sha256 cellar: :any_skip_relocation, ventura:        "32d85edd7a6c1a02820631cf465d6a4673a427d6c35f9452f52019e22aa0fc2c"
    sha256 cellar: :any_skip_relocation, monterey:       "3d291cf16beb5a8469dfba239b481b205e5476a71945ca78df63295395d5bef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fcd228f3e0af24a8930ae81b0edc4ac3f3e90b644fdff9df5340f24feb8ee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b286dd9dab3ae2656f2b1ab07a43df4b4348c156b7f30f538c0ec356c6a36505"
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
