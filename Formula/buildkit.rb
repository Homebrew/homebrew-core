class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.6",
      revision: "0c9b5aeb269c740650786ba77d882b0259415ec7"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "509ee6de96699aad0ed3b7507d37e2da00860bbabef2c34197daf0213f78e85d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4c73ff458b1389ba80f359d53d47a8f131798333800a5124d2b304aa0383bcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3e949728c77522bcdef40df6f34b5545e5eaa3dd99c2c9fb24a1becc2da658e"
    sha256 cellar: :any_skip_relocation, ventura:        "2c938796c6edb00ed573cb6c71a65a0e13233636a39d431b0028e8a126d5d9a5"
    sha256 cellar: :any_skip_relocation, monterey:       "e0445eff3198cea041de0a16faeaff54c3890d5e538b0be88b645d6341d109c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "601d2798288827c90fe41a6b604a6c3bcdf8bb5417a4a82d9e95e2d0439afd17"
    sha256 cellar: :any_skip_relocation, catalina:       "39aa31ea54d3c8a8f1b83629f53924fdf2490a32383d3fe09b57fab25d0b5d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f3b689b569d845554ccd76c76df786e14ca7091ff0b602305103c23e0187b7"
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
