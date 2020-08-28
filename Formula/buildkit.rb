class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.7.2",
      revision: "22e230744171b4442101731951bbbecf97796ea5"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b3fb77472c881ebcdfbc72cbd1c0dd236c29bca54ea64551bf4f7bd5dfdf8e35" => :catalina
    sha256 "336d451ad65d94ae7dc95bd56cbddb39d79774a2e6e73178cb7d281e5844cda9" => :mojave
    sha256 "b11635ac82a9abfd99e7f796b4c8f2cea8a0219651492d6de70336067d97708e" => :high_sierra
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
