class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "1f58a1aa1fb3d54fd95afe6c737368c861f794f59c8e38707f98a5c39f093625"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0328d1404b316f616383c6d9f5e44a65ee89b13431feb30e4345d77e72be05f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0328d1404b316f616383c6d9f5e44a65ee89b13431feb30e4345d77e72be05f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0328d1404b316f616383c6d9f5e44a65ee89b13431feb30e4345d77e72be05f4"
    sha256 cellar: :any_skip_relocation, ventura:        "98b209365fc65974a69372ba039b8327593efff429ea2b20d6d78a8ef08271ee"
    sha256 cellar: :any_skip_relocation, monterey:       "98b209365fc65974a69372ba039b8327593efff429ea2b20d6d78a8ef08271ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "98b209365fc65974a69372ba039b8327593efff429ea2b20d6d78a8ef08271ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78b435f1181af911f524f49c4c5453718a31c7002035f46409c1e6a7abef999"
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
