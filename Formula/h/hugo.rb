class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.161.1.tar.gz"
  sha256 "a429b730bdb0150a564de091a21fbb1bab8a63555768531077b8fbacc8d3742b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "379487d8fa51a69eb5565606b4c57d928fd58e4777a6e7671fd56445d2bde86b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de0c8bc9656ac5576285263d4d1ee36bbbc1115d0bba617522034d9c42294066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "898074e28e6dbea6b50d61ecf9d3ada150964527f9b7becdb549c839131bab90"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec92dee12b2dfd6a9773a278215e16ba71275fe48401f8c17a1155371ddcc26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13d7f0814f16891381b2ce894480cb3da033de87d5241c8c990115e55bc7466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b2a2b53bc0b8f05de4c0f8389e91b5e5140b5e09c92902dd2d844185bec74d"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end
