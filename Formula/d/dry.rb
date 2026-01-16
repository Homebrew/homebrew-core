class Dry < Formula
  desc "Terminal application to manage Docker and Docker Swarm"
  homepage "https://moncho.github.io/dry/"
  url "https://github.com/moncho/dry/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "8fdb888f3f0c2298c531d5e23acfc0a55c7e4e881ad7365cc0dbecb8ec6c3b89"
  license "MIT"
  head "https://github.com/moncho/dry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e6af1ea465a5651b74549561892f63d1116e4522354cb27572fe9e31f170c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41faddce9db56bb2fb2d505456024e950efd748a4573d725f4e27fee9c4d2163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41faddce9db56bb2fb2d505456024e950efd748a4573d725f4e27fee9c4d2163"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41faddce9db56bb2fb2d505456024e950efd748a4573d725f4e27fee9c4d2163"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c27ff03f7517fdc5cda2e0f4e73d5b3cbbdc211bfdab8ee83cd510bd7aff90"
    sha256 cellar: :any_skip_relocation, ventura:       "99c27ff03f7517fdc5cda2e0f4e73d5b3cbbdc211bfdab8ee83cd510bd7aff90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90203ead2bd5e5a9211fcd1086b41fb6cfd48396f5016341578703fb1b2ca1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3d2be362eac6193b8e570dfbabd9a826e92e3f1b58bc05687c46d3389cf81d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moncho/dry/version.VERSION=#{version}
      -X github.com/moncho/dry/version.GITCOMMIT=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dry --version")
    assert_match "A tool to interact with a Docker Daemon from the terminal", shell_output("#{bin}/dry --description")
    assert_match "Dry could not start", shell_output("#{bin}/dry --profile 2>&1")
  end
end
