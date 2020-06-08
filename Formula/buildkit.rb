class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      :tag      => "v0.7.1",
      :revision => "ddd175c5a2cc24530ea8ff427887c22939ca4289"
  head "https://github.com/moby/buildkit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "015f74ee73a6d745263b7a46d0f8ae09ec2f8f2ee2c48372cadb10003ca3c05b" => :catalina
    sha256 "befe8115b0af92a43a56bcd5ce5566d53cd7f94594a55518a069abd5a9055def" => :mojave
    sha256 "02e8b1b9949bed96e5f5b69f12513622a89d7ad7d244241081bb4f6ec8af304d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    revision = Utils.safe_popen_read("git rev-parse HEAD").chomp
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"buildctl", "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
