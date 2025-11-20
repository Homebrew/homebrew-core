class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/mkubaczyk/helmsman"
  url "https://github.com/mkubaczyk/helmsman/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "1fd57af9978681f0c148157e5ef7929b5154e6e79bc13c41711892340320254e"
  license "MIT"
  head "https://github.com/mkubaczyk/helmsman.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8ecaafb1e57c171a70b8cfb7fc3fb092221fe15c3ba1c023edde5b1c34a075d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ecaafb1e57c171a70b8cfb7fc3fb092221fe15c3ba1c023edde5b1c34a075d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ecaafb1e57c171a70b8cfb7fc3fb092221fe15c3ba1c023edde5b1c34a075d"
    sha256 cellar: :any_skip_relocation, sonoma:        "df0dec77079f9f076bea666d21c926590e9ae249075855de3ded50cc9158201c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd35a965fa692e7aed7ad3bd75fb1ba817707facf415fb4ab903e020a99fbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ad3b1643c247c5cae4467ba1c7e8a8d950ba7cc9fdb746bd9ff4800c8e7ab6"
  end

  depends_on "go" => :build
  depends_on "helm@3"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml", "examples/job.yaml"
  end

  test do
    ENV.prepend_path "PATH", Formula["helm@3"].opt_bin

    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
