class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.158.0.tar.gz"
  sha256 "4fc3aecd14bf24bc8a18eb3337465640fecad91c83876fe26ba5fa1ae9fb6f1e"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dce1b9e208e1db0e8fc447a8d012bea921a14552357ee953fb6851ff7751f383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8464b39266eda9d0ba9f46d51a894346dbb9a93c1745ebb9209903317bfc6be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "716ac24d2ec6fdc904f0df952f64ebdf3fd8af7ebab3ceba91f15f03a5c8dc68"
    sha256 cellar: :any_skip_relocation, sonoma:        "94fa25376571290deb8962bef99af51907222d85b897fe1ab2175ec6fd163408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97606c6dcce7e6cf1c5788a6573849e285b945b70fecd59002e92289aee688fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7228ded64a63e92c2718b65b339c50b13e78f63682f4394b6b75b94b7ff1a55"
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
