class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "7b18f3f597a913912843fcd6eb52b926e343a2784b2f1009fce9e196fbf9ca03"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a26f389d2aa2963eb9a9b21ff8b5548ad72a4db54ce371e6ee91faab6bde2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a26f389d2aa2963eb9a9b21ff8b5548ad72a4db54ce371e6ee91faab6bde2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2a26f389d2aa2963eb9a9b21ff8b5548ad72a4db54ce371e6ee91faab6bde2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad4191753f44bb706ce4007ce56f493d32c3f7647ed69a212372cb4d227faa65"
    sha256 cellar: :any_skip_relocation, ventura:       "ad4191753f44bb706ce4007ce56f493d32c3f7647ed69a212372cb4d227faa65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b8219056b20d747b9ec219286d5ec02f1334a7fdae5f803fd87cc68cb6badb1"
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
