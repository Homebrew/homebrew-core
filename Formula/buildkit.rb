class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.4.0.tar.gz"
  sha256 "8847b4ece48a40dd17c23f288152bbde90c623a7c8162e40ebe7f3e25dffb54e"

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
