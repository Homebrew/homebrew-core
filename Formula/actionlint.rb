class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.12.tar.gz"
  sha256 "c5cf498a963df6292fe7e201281150bef8a7ac45272f3d988fa3f122a270225f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9319c42456a123d9b88554f1ab2de41d020c5af68c97feb83d1df56f931154e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9319c42456a123d9b88554f1ab2de41d020c5af68c97feb83d1df56f931154e3"
    sha256 cellar: :any_skip_relocation, monterey:       "dfa84653ef8c4684b4e64455740ecc81fc9fb94aeaa431a2b86421744d326465"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfa84653ef8c4684b4e64455740ecc81fc9fb94aeaa431a2b86421744d326465"
    sha256 cellar: :any_skip_relocation, catalina:       "dfa84653ef8c4684b4e64455740ecc81fc9fb94aeaa431a2b86421744d326465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94af409e060ba1d8fdadda3753928457d024e3ff18fc5409b465a1b2696b285d"
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
