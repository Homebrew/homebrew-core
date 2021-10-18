class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.6.tar.gz"
  sha256 "af5c9e93053c16204d9d92d3dbc7bb3c1cd65f259d294a69e45af45113fd79ad"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "18159c42918a9238bbe984fca3a1e36d57ce3ec4bd31d1b4fb466c84746f2070"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8f1817f2515cf5840af30c555fd736d59213e2bfeed2f1f2e3866c96831df4f"
    sha256 cellar: :any_skip_relocation, catalina:      "c8f1817f2515cf5840af30c555fd736d59213e2bfeed2f1f2e3866c96831df4f"
    sha256 cellar: :any_skip_relocation, mojave:        "c8f1817f2515cf5840af30c555fd736d59213e2bfeed2f1f2e3866c96831df4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "228bcb096b64dce17a5660e7362c088bebc38304c64af3a35d8faf9dc7caec9c"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/rhysd/actionlint.version=#{version}"), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output(bin/"actionlint #{testpath}/action.yaml", 1)
  end
end
