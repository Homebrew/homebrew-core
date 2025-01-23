class Bender < Formula
  desc "Dependency management tool for hardware projects"
  homepage "https://github.com/pulp-platform/bender"
  url "https://github.com/pulp-platform/bender/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "939ab78fcc9b02947db0e65363b8ac8e9a2109f02b2abd646fc9591b036136a3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/pulp-platform/bender.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd8b3f5f21955489f860b5252a7031d6c273b41d21d96fd57400dd9b3d9d904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e5dd2870beb9ed45d9b835fa622e1ffa7e408283dd3e726bdb7bc1dcc513f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d2fd9220dff775ecbbffc29e3c850b5177ef17d40d6ba1a743c94ddd206432"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6dee9c5314b725b98d41016d9536d1bda796568509e8b796db95b8d3793bfb"
    sha256 cellar: :any_skip_relocation, ventura:       "4fedd2bdec31a7a97afb20caf6fbfeaccc54a0fca696800b50cfce36e8ad7cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7123ba3f46b315c38409ad40b3fe5a1f0f7a26ffec2017a77186b6cc053f7c80"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bender --version")

    system bin/"bender", "init"
    assert_match "manifest format `Bender.yml`", (testpath/"Bender.yml").read
  end
end
