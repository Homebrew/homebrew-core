class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.8.3",
      revision: "81c2cbd8a418918d62b71e347a00034189eea455"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfc1a7eb1b24c248f64d4925d4c52f4d88d6ec6c19502a9677becbf95a534dee"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d8d9b69f4757bcfff266f90086a607d428b6dce9ef18fe19fc7d2dc9f1b9169"
    sha256 cellar: :any_skip_relocation, catalina:      "c8f6f789e3ac8141f0229e9145f251093e06d072ac10110406844476a874a1b2"
    sha256 cellar: :any_skip_relocation, mojave:        "4574312ef4f5f9c6d6d9beb6049c77cad27f316609f93ad556f969bed317d425"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
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
