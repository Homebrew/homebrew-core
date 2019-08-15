class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit/archive/v0.6.1.tar.gz"
  sha256 "04fdaa6ee9691971ce385fbdd67401b3d4f0adfa3be76b52b35b6a4ac5dbd50c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8899246f742da7662fd76e8d1f0bef9c6fbf987b069dfd874377b247937cdff9" => :mojave
    sha256 "09793da8f770c03cd85965f76fad5422c207c56ea64fdbaf908d89c310d7cdad" => :high_sierra
    sha256 "a243c194d9262c6e564b7c8e5f22aad0e57fa43f8de32b81ae243da1ebfa025a" => :sierra
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
