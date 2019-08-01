class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.6.0.tar.gz"
  sha256 "ba00debd8ca7ab27a65553b32ae092ce7a5e058fff2d5d3679da07332041b368"

  bottle do
    cellar :any_skip_relocation
    sha256 "51cd71cd4ec5055cd2fce2495667838074984254f320703176e62498e6b2ecdb" => :mojave
    sha256 "c2cdc467de461d6a5f6b8ca3e79bfcb3e505d90a9834ddc76f49fe4b586fed8b" => :high_sierra
    sha256 "230e2dd29a73debf18c9d172c765a8af93acd9aa14e12312e5fc6add5ab84589" => :sierra
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
