class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.6.2.tar.gz"
  sha256 "1eaf2c85c20d8da283e48548954484883354df66c6a4c2dc87bba7514a7ba99e"

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
