class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.10.0",
      revision: "068cf686a7e5c3254244d0acc54636f4f393611e"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3caab33349a360ec9370edb7970307ce9fdb23361c742c34a6f7171d56d7ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed273fa26af866942e2dcd6bdee0ea768740e21519607bd195f07ed99242f29e"
    sha256 cellar: :any_skip_relocation, monterey:       "4409329bb7bedd82c5634dbf8572077814a14af663311333819a1037acfd27f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd64bc2daa0de481cf1d867f61d0d50362c8a9d44fc712a3d9ea2040cb859c6"
    sha256 cellar: :any_skip_relocation, catalina:       "95b19784b8d086973cd81ef7af681bfbcca4f212c997748c0ec96978810ee949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ce198eb0ad3c2f4ba7e06207e8643ec715d755c432538cc246bfdff34f839f"
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
