class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "78fac0235fd583e28d961b0fd066994095a9cec4d5a834747833bbab042ab1c0"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fb8d419320e9755d8a337da3cd37d7e6daad352c8d8091f7622d1770f4c8426"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a0291112879d526359da3606275624b7f12495dc35b2466889a321072534b8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38c1c3ebda2855d413bf24856a5ed101ab9035e8a0068db9ba9fc54c742cf4d7"
    sha256 cellar: :any_skip_relocation, ventura:        "53f91331cddbc45fb14b7233372917f92e8121a29bf7e44ce6a1aa07f54c5003"
    sha256 cellar: :any_skip_relocation, monterey:       "a702ee3b9897f45d13f58dc6bc242753a42a8e097b525dcaa8b9ce957e906332"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8ced503bd536a8e7c9c5e808210110318055a95cd009e19f660f65ba805fd44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149d57239558c13218f57540b2dd34b49923599fb3af838011de3658cfe59a1f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
