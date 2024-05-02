class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "bb54639c1e9711fd6d2c88f15abd5d3a31b657d5b182154db60a32ee93ee2713"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "badae3b8b62d0c18e663bb183d49fd47a599a965fc37cd148f81e9be77150310"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0245ce18c9bab9f9de4bdfff5aa87a997f6530f612d6b780e5aebc9816640c78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1ca7044d94e84f2558dc96dec20916c6968a4344d47ffea0767fd765bcc3a55"
    sha256 cellar: :any_skip_relocation, sonoma:         "daffa2f0d1ba1460fe11028b6099dca4dea0a5c1613ce09da448a70ed28255dc"
    sha256 cellar: :any_skip_relocation, ventura:        "53a4719c990267cdfee1a7af1be19f506f122459cc4fc2b3ee392890c539276a"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb24aef8ab7aec24363141fe01fd16875a84638078cf3cbb11903e4624e4a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8222035b37bcc11ed13382fbd60f162a59baaedb265a0c86e285214aff332f1c"
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
