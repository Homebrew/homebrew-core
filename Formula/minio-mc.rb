class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-12-18T10-53-53Z",
      revision: "d0e1456be34f39548148af45c2e64a61b3448a59"
  version "20201218105353"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([^"' >]+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aaeaac10b93ebb555c88f473180d31500fb6db91c3f4cea3d5f925c1d9ec424b" => :big_sur
    sha256 "0c64ab8f00baf4397c84253f04950bb4762cb49835ebedb7e9767f3c0df4264d" => :catalina
    sha256 "b6bf21d0cf4d90897525a087099f59c9d01f90554f875f2ba62d858c39a4b971" => :mojave
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
