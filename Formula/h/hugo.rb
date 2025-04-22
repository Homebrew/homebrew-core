class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/refs/tags/v0.146.6.tar.gz"
  sha256 "7601d65317610844a8023f28a2acc105c3a202d0aebb5ec87651789da8d6eab2"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55647555ac0627c9915190c5c73775701db40df55bcacedf35f1a729be847e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "057ec8b155d8e3947f1d96716ccf7fd830b6cc1a87283e8d7694bdbfbf7d222e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "904b07ee2af05e746502dfda3acac9a892fe6d3411396320c52299c825e7627c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd6017d7611796cc9721faf3e1f44d4622bf0529d42bed178c6d4491f950bd49"
    sha256 cellar: :any_skip_relocation, ventura:       "fada6f4b4137e58d91d60f51b69e2d688b24ed3b5aff66fc20d51f1d008a37b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72aa1459f7085640226a85f69e985db6dc970f667db6aef2d61a8eec8349ee9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af2a72294e018352ebf903eab8191e60df00264e1eba1ecfec0f54c20600cc2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end
