class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.9.1",
      revision: "966bcf4aa3ef397a9d6025fade18f2d59a5bf29d"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c22d508193cfe56e5b8ec71f61ecc34388c653b38e7155900bfdd8b7b18629a"
    sha256 cellar: :any_skip_relocation, big_sur:       "adf2f6c33f5e983f976878e6d08651768d0886a2ab278b058f9c98c59ac0e448"
    sha256 cellar: :any_skip_relocation, catalina:      "5e37392ee86e87e761cc55d1e41ed79d742d61e9d1b5e46076b3aa2f995155ec"
    sha256 cellar: :any_skip_relocation, mojave:        "c800bea98b6f719f7fbd2be4c6ef8bd9b0b970dec494ff6bb8f3103146b5bbca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb09664236cf2ec40669e8cfffcb29312f31ac8165b8ebcafbf0f15b4ecc911"
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
