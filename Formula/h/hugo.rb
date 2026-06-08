class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.162.1.tar.gz"
  sha256 "17bb39e6af89d9b176bbfb0c06caf382d2f2af7644b769e2eab28cc084c91381"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fadf86f668fb150b0268bde8670b757fd4df85a9588ac3a9a23b6a6e425803e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3dc0c8cd04bcfe3f6264b0de5db9a111829e0fe42fb7905f0536a6f0dafcd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c87be992027cbbeda9598e021fbab3e278333a59310e656fa5055d2185ba23ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "08fc5f930b2f729fd5d94d9f60c0ee9f23e3f70c916c3f4068607bfb463f078f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aca973ba69fd33c73940ad7dd648ccef6538b5871a97ef2f6e5d6bb3b3fb70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d3e4b5d7f091031571d2f40130597a2ffbf8ee8d3cec4d88a8d8daac253a121"
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
