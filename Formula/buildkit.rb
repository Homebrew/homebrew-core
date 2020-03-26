class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      :tag      => "v0.7.0",
      :revision => "c60a1eb215d795a12e43ceff6a5ed67ce1ad958d"
  head "https://github.com/moby/buildkit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f3434b057b7ca11acae7253d2958f4899923690feaa21a859da3b46045a8fe7" => :catalina
    sha256 "0be4b79f2cf44458b7746acb7f037de840cc37c825085aa7bdb9b4a0b17089d6" => :mojave
    sha256 "4bb92b743d2dda2f3676d9eb722ef534e7fd468f5b123b3170a7fd4a8a898350" => :high_sierra
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
