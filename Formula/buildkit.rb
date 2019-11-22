class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.6.3.tar.gz"
  sha256 "b455ee83340f08b30c64918da2cce6e4f97cd8d0f65aeb3f640ca93d19f17e56"

  bottle do
    cellar :any_skip_relocation
    sha256 "141564f8b4022d373b0044dba55311dcdb9b199ff5863a38c07445ea9e1dec79" => :catalina
    sha256 "f665439d2055c8e4d1825c98abea066c8b4b16a3c50c0f85da8c295f7f2da812" => :mojave
    sha256 "d7e0ebef7d4c67cf5054b7dc2d95b4e99381a5cce86f9d19246f8729f50e4029" => :high_sierra
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
