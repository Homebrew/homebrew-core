class Ov < Formula
  desc "Feature-rich terminal-based text viewer"
  homepage "https://noborus.github.io/ov/"
  url "https://github.com/noborus/ov/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "94a712214125fd6de24f0235e7aa8aa83d9220213036c73065321f2cc9ff2483"
  license "MIT"
  head "https://github.com/noborus/ov.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88277d3ce18f3128f41ad3ec0ebf1870cc519f093f159192547c668d58a42912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88277d3ce18f3128f41ad3ec0ebf1870cc519f093f159192547c668d58a42912"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88277d3ce18f3128f41ad3ec0ebf1870cc519f093f159192547c668d58a42912"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0bd7d5ef24ec276005db2a9831f9c3c49754823801f007843285be36f06412"
    sha256 cellar: :any_skip_relocation, ventura:       "0f0bd7d5ef24ec276005db2a9831f9c3c49754823801f007843285be36f06412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e57655b4bb6eb58ad275588f6edc6109c5bdb96591e16f76382a03c9a4b164d6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ov --version")

    (testpath/"test.txt").write("Hello, world!")
    assert_match "Hello, world!", shell_output("#{bin}/ov test.txt")
  end
end
