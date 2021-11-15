class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.9.2",
      revision: "a14b4e097ae1dc7514c5febd6d75f742a166ea75"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d47eb2ecd2e36ee0ee7ac63103134dfcd80e208c2886e812d767416d13a658"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cef0a7f2b373cee7c31aa6bd458fdd31d0f14504b68d39959e98f1c12dc81f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "188b3ca1bc597294653b18c8bf77046bc9cc9ea85cc00a8310bf2df58413aca9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4076c656b0122f1aad027149270b2e510bf7c3edf5cab5d5eb13d6659f4ec041"
    sha256 cellar: :any_skip_relocation, catalina:       "a14409eed8abed2eb4b74fae761f4a85786d19fb0d2a3b2349eaf0d370fd1a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9de9c6adadeca3f9911d3de8bc2433010b48b45f7c8863eeafdc7c9d1e405b1"
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
