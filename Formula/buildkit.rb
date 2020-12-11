class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.8.0",
      revision: "73fe4736135645a342abc7b587bba0994cccf0f9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/moby/buildkit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f34fdd44e61c1ab563bd7bbd2a8a5f53d7b4442016bc4144ae9bc7151459a35a" => :big_sur
    sha256 "ca5c093acb45400e32fa5267667e3c3bd95dd1052273737ca28e5dcc082d37b4" => :catalina
    sha256 "89c49ae30f571168014007ea11966aff9cbd355672d47ce11a6365f529387509" => :mojave
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
