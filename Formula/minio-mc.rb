class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-02-25T18-10-03Z",
      :revision => "67e90b8fcbc9781fa3bf2d183cd457c2e5267f81"
  version "20200225181003"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b04289ea8f7a3a0e34ff051f87d29ebf08ed2dcb74307a5b22cf991bd65c4e8" => :catalina
    sha256 "63ba99a88034044fa39e15c52fbfc66dd6b13633778bc7bcbd0e25141091df60" => :mojave
    sha256 "a819a64896b4011b9edd24cc9e0595aacb6db319dfaae81652ca6d5f61a7185e" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
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
