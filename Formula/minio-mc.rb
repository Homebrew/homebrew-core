class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-07-11T05-18-52Z",
      :revision => "1513d76ca9d3a2cddda40d0e6e50be164b894889"
  version "20200711051852"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3e9d880b26de8185b686342ec11066769a8b8d96ddeb8c12679f01a644bea97" => :catalina
    sha256 "36f68fb6f0e4e068cce1df13f1e4b3b0360e47ec01d1af4219f442c9f28723db" => :mojave
    sha256 "b3e3584fe6a7bded08a5ec2f4795b81f4d0f254599e5b36052502a0836c32e13" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "both install an `mc` binary"

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

    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
