class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "812a606ec4a8123212d7bb5402cef5fe56ba56e0f7c1416b86eeca7647a2c582"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e92265086b402c517158ab0b1d4ce3430852db17129147e11f29cb3b77c4c875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92265086b402c517158ab0b1d4ce3430852db17129147e11f29cb3b77c4c875"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e92265086b402c517158ab0b1d4ce3430852db17129147e11f29cb3b77c4c875"
    sha256 cellar: :any_skip_relocation, ventura:        "852590384bb1281a15d7239078c7023446f37b4bb8717b6bdcac3a316673cd20"
    sha256 cellar: :any_skip_relocation, monterey:       "852590384bb1281a15d7239078c7023446f37b4bb8717b6bdcac3a316673cd20"
    sha256 cellar: :any_skip_relocation, big_sur:        "852590384bb1281a15d7239078c7023446f37b4bb8717b6bdcac3a316673cd20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24e5a6405a62726184443c09ce86cc15914837bb739ba237096e63445a612d5d"
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
