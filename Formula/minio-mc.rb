class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-10-03T02-54-56Z",
      revision: "f11ae85566fea61b998cd7c168d5a4dbefe831ba"
  version "20201003025456"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/minio/mc/releases/latest"
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([^"' >]+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1c9e4d77d0b729dc3957097b6ccb2ee6ad657cab6fc383501513c6b0a13567e8" => :catalina
    sha256 "004eeb59ee2a7a3aa31e59961e45a9bda586b405df9f6ef4d5b7fb0913097a2d" => :mojave
    sha256 "b38a3e40b159cced1c32def784172f177511fa44ba0947cea6b4d8d9d1099313" => :high_sierra
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
