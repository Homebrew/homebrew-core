class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-10-03T02-54-56Z",
      revision: "f11ae85566fea61b998cd7c168d5a4dbefe831ba"
  version "20201003025456"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d91d2b0a0420fdff205eee43a2f44a6992b6b537d0917e894b071787c66bf74e" => :catalina
    sha256 "d50574389e6fca78a78320d858cce6bc0a69736cde88c21e379e9457b9ec3d92" => :mojave
    sha256 "ee4412b85331ac98fbf781c3debfc33b5747b08a5bd8b9d60879ed2390a34b45" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
