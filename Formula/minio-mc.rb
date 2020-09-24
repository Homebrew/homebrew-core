class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2020-09-23T20-02-13Z",
      revision: "db1b508d8b418ef67617a9770b0d0020de427f88"
  version "20200923200213"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "65d84a96e6b026f5026d7a04f587ac3bb5902bf958226f0c43abfd37792339f6" => :catalina
    sha256 "56f0b289f7bcb488aea4938271c75e8a5781b6e378b8d7beb5caa4e80608f32b" => :mojave
    sha256 "1d2086f510570ab88ba28d630ece6a55cb9cf25cbb6825bc16439ed4421fbcae" => :high_sierra
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
