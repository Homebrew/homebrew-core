class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      :tag      => "v0.6.4",
      :revision => "ebcef1f69af0bbca077efa9a960a481e579a0e89"
  head "https://github.com/moby/buildkit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "141564f8b4022d373b0044dba55311dcdb9b199ff5863a38c07445ea9e1dec79" => :catalina
    sha256 "f665439d2055c8e4d1825c98abea066c8b4b16a3c50c0f85da8c295f7f2da812" => :mojave
    sha256 "d7e0ebef7d4c67cf5054b7dc2d95b4e99381a5cce86f9d19246f8729f50e4029" => :high_sierra
  end

  depends_on "go" => :build

  def install
    revision = Utils.popen_read("git rev-parse HEAD").chomp
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod", "vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"buildctl", "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
