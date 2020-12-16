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
    sha256 "44ed9f2463553fc3fad6d21062327e86c4681d06e4ab6ae102a88aa3fa8a24bc" => :big_sur
    sha256 "60fe6f4e4181818d22e5df5add1bb981c8378c94ca6bfa902739374021116b7a" => :catalina
    sha256 "ffd11913f4f57d402b91668bbc3f2bf3d44031ff4bf991f419a54e2e7201898f" => :mojave
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
