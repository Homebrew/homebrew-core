class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://github.com/helm/chart-releaser/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "288fd5a6c6b761312103f499a0e6a797f5ca11ae903f5ab88a6557712b962715"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27092d541b6e311d481975577cd01d6e509d7dbc7f3ddfaa0d79a4e0403a9669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac48c960c540e8c832e43cc300ba9f111ef826b42d4b3ebbaff903935a0ff148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abeb352ebc9327bebb195149adaaf36e73a54a4a4e22ea943484d57d7791206f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95bdc0d6c088802e3c2ee6d70494f72204bcd2f569fad4a31cf132e5340f120b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddc5b4d029ee37526c683ec7a4256dfc3341a4b8d875a5b3eae9d203b94c74c2"
    sha256 cellar: :any_skip_relocation, ventura:       "d62fedebe1170d0a230308039b7e13d2bf9843ef03956e9f65b4872041ee3843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "794471d16801611983bb9aeed61f96500f7f985c9eaa12d8d9a419fff04f2ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c54dcb307cf826eb4cca3dacac438de2f0110d4b84d4dfe36b39146c633229e5"
  end

  depends_on "go" => :build
  depends_on "helm" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/helm/chart-releaser/cr/cmd.Version=#{version}
      -X github.com/helm/chart-releaser/cr/cmd.GitCommit=#{tap.user}
      -X github.com/helm/chart-releaser/cr/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cr"), "./cr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cr version")

    system "helm", "create", "testchart"
    system bin/"cr", "package", "--package-path", testpath/"packages", testpath/"testchart"
    assert_path_exists testpath/"packages/testchart-0.1.0.tgz"
  end
end
