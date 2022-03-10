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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d5a09ed1359370c6f26bf560dd442a626ca6cfe0fbcdaf98150d9b3c195b3a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1efd7820f22494c539e5b484962ca93067759aea165b7d2a1db71ff2e9c6552"
    sha256 cellar: :any_skip_relocation, monterey:       "9d8a47317cbbe12ea15bddc03329754957344c72b59bcd92db9c246485b3cacd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e65d638f326d717fd2a72a89db39ef66818d2fa229794d315a3f6aae613f78b2"
    sha256 cellar: :any_skip_relocation, catalina:       "d1639fdc290f2ea6c5820d2326a2022ffa7c515bae6f89db96c59172bc5841b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed75a3aa2858011f0cf8665b94a44bec0cb851cdadab7c805682911ad415084"
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
