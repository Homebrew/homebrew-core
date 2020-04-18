class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      :tag      => "v0.7.1",
      :revision => "ddd175c5a2cc24530ea8ff427887c22939ca4289"
  head "https://github.com/moby/buildkit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2366e2aff20896e75b862e054eace8f08b6df35b91874f6bb72e16d05d8ddb9a" => :catalina
    sha256 "d3ef111b9494b03c7c3dff185f59b9d2299e6d2502c0959baa1b7cdd1807c6ae" => :mojave
    sha256 "fe0166769a3ba14f3d307c5b363563e88898455022efe8432acf6210afa2e750" => :high_sierra
  end

  depends_on "go" => :build

  def install
    revision = Utils.popen_read("git rev-parse HEAD").chomp
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
