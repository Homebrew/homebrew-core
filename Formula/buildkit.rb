class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.5.1.tar.gz"
  sha256 "67f9737aa448725823eb2100a2500162719a3eac2664aaebe70dd6a0818b8341"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f634899aaca84e3d42ca8898fc606c0df156c2999ab58ffdcf0f784123f5ddb" => :mojave
    sha256 "280f1fa42108f0cf3c81ecbd2e00b2c9950a32a9f021aede0e92c23159d242e0" => :high_sierra
    sha256 "f3e0139b50d363adab37a886915a96d0c4e80606cb6fc82b0451f18e9a2badfd" => :sierra
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
