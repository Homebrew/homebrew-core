class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "3a6948ebfe9bc5fc19dfd0f7ec7d39737c8d702c35cfc457ad53da179e9dcb90"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b92d09a0599c0939eca201a1efcdcdd53fdc3d469a2f67f83f0e60584f81162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857ae3c0ff83f3fff9fe10b1badf160adfdefcd9da434af8f3d470ee8254c3cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f493ae713b4e2a82de582496980c62d2aa27085b01c06de2d225f36573e159"
    sha256 cellar: :any_skip_relocation, sonoma:        "89580a3b6badcb1d0edd2b383b018da64eee7b25eb8e4a7e578c1e97236a7c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba1279c3b3e1e20a19e7cc9cadb2a3d8b8fbcfa6ca82f8c03668c84a9c62b866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f466103e10577bb7945fbdd3d7b8dcf3f99a5932e2dae6dc08b6ee927d86b55d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
