class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      :tag      => "v0.7.1",
      :revision => "ddd175c5a2cc24530ea8ff427887c22939ca4289"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "58adec179c6d2f4467ecf67d5d3766e2bbce610b0ce69a2a36459fa5c067c183" => :catalina
    sha256 "8ccea54a8f06cf3048da19403c362b5a9965e76728aa23ce4666f1846e7bd745" => :mojave
    sha256 "86255f3dd127dd0cafdfeb46d777f7c1faa2864ae1162ba79261ddee0a142f9b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    revision = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
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
