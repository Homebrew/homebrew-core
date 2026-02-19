class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.156.0.tar.gz"
  sha256 "7709fffa812587eb390b380c31a1139dac7227eb5e521539b884bf03f9c963c8"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a19df619afaa46f48cdec0c62e4c03c94bf3280eba9f8de16a51e6dc33e5ab0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65575c04c9bf8d64cd7100da2f53c1ccd819f5161bbcb79bc72aea0a5da7192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "873c2562bcd03e35dc2160b5f4a698be5ab90a63ea18eb52bcf9808ce32952a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceb3c7b16b0c72834c6967f6e7654ef00aafd78d1899943a8c73a0e19968782a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e86a20432f653c5e0704a38396303a71f127581453e63cadeb4503f31faa483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1ff7e960d7b92662a9bacee88c9ec6ebd91c3f91a4788c773ec3747cb2397a"
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
