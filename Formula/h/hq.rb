class Hq < Formula
  desc "Jq, but for HTML"
  homepage "https://github.com/orf/hq"
  url "https://github.com/orf/hq/archive/refs/tags/html-query-v1.1.0.tar.gz"
  sha256 "9e4fba11fa8d659ff4e875e05aab1a6a46c79c2e24be061ccae82714867ee919"
  license "MIT"

  livecheck do
    url :stable
    regex(/^html-query[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d0b062b79d1d3511e1e73f49b6c651c0d1afc078a5462364e5844b06285013a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50c29f56078634002477f234e0a0d45c2b148e67f6c397fcaf3c1976dae3b8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf2060bb7c2e6b849045317ad44774afbd23ff800c13daff4150f85cea7b061"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7a18e6a1b0ef5c2e93340b812ea885fcc2cdd404320faea37c0e80dfad18fd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec5124569f2ca2d1f270b7abe72f238ae1d72f0a7e1b745d27063424386e76b5"
    sha256 cellar: :any_skip_relocation, ventura:        "999e2e1e44e3c8a9ed6ffdc85aa5eb4996278083c3e04d223bef6395eba1b2f3"
    sha256 cellar: :any_skip_relocation, monterey:       "38ef4f2dcdbf7390e77bf9fba02c695f96ea7dc665b9ec191ecf2472257d83e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "394c038d392894d97c8c10a5f3e069869422ac1372a0517703c00d9fbb72f6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40860d53990dbef78aa285e5441e8a5fbb6465bf7c85fdb44c6db8a61c0d71f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "html-query")
  end

  test do
    html = testpath/"test.html"
    html.write <<~EOS
      <p class="foo">Test</p>
    EOS
    output = shell_output("#{bin}/hq '{foo: .foo}' test.html")
    assert_match '{"foo":"Test"}', output
  end
end
