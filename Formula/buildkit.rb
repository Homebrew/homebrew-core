class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.6.1.tar.gz"
  sha256 "04fdaa6ee9691971ce385fbdd67401b3d4f0adfa3be76b52b35b6a4ac5dbd50c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c26399362e74950e013665d7724b0b4da265a936d19b9d351578375bf5cd896" => :mojave
    sha256 "8b2410b03ae170c277f4e7b71b18e2f2b5e725838cb55f3222c7c2f9135818cb" => :high_sierra
    sha256 "84c2d3967896d6367036273aaa98b46dff5e9929a66685285efa76e451e591e6" => :sierra
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
