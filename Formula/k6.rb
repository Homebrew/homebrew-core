class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/v0.41.0.tar.gz"
  sha256 "9ded31c8e6a256e6bd1749f734f1a512b026184b0798f2c203b2cf82d1d9e107"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7d2ea81b3fbc1de2422d9d34c0a6563385847ee6930e864d6e381eb4fec372d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b517175c0d0119124edae6bea02c1e4399ad62deb1a27ad3413519366e7812d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "363aa6c32f151811537122c0b9d010f4109ec5ad30a4ce94e76fdf10050786a2"
    sha256 cellar: :any_skip_relocation, ventura:        "e12e34c80ac4a6e3938fd6c76f35a8ee91f510e1f5de7d57c6a9816e40a0337e"
    sha256 cellar: :any_skip_relocation, monterey:       "22d94dc3cf19e1c59ecfe22a1819e0a67e2380f31d39d14f233bd39ccf49af38"
    sha256 cellar: :any_skip_relocation, big_sur:        "784d2e9be659d8f902318889264df95354e15d8b7048e28b186e36befa3d3f87"
    sha256 cellar: :any_skip_relocation, catalina:       "540d8fa843dc40b20f4ae6964777fedeeaf0774ef4128efd3ab87b5d7420d802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722d53c93f0a7397e144d9f56f28006551a6e3d8106328168209b88e50cfac84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
