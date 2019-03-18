class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.4.0.tar.gz"
  sha256 "8847b4ece48a40dd17c23f288152bbde90c623a7c8162e40ebe7f3e25dffb54e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1d4b627eb74827bd3730c690dc1efb0a29a28c4ec7eaabe8c2b7dfc2a4261ff" => :mojave
    sha256 "b7c7421f5e52c3d1f73eb8c659bb2da0dcc2ce75b44a13a6922dbe30b0c369a8" => :high_sierra
    sha256 "4eca0585defe3f79b0f436e54056e36b0c130c917727cac6be7eae6a86ad33e0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    doc.install %w[README.md] + Dir["docs/*.md"]

    (buildpath/"src/github.com/moby/buildkit/").install Dir["*"]

    ldflags = ["-X github.com/moby/buildkit/version.Version=#{version}",
               "-X github.com/moby/buildkit/version.Package=github.com/moby/buildkit"]
    system "go", "build", "-o", bin/"buildctl", "-ldflags", ldflags.join(" "), "github.com/moby/buildkit/cmd/buildctl"
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
