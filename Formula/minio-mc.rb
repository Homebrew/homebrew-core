class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-04-25T00-43-23Z",
      :revision => "201831912545c5a16ca4c797204eabb4d16ee7ac"
  version "20200425004323"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8795bc910f2e1b7b8a7638a2956840689f9ecfe58cac1437ecb3dffdeed1f8e" => :catalina
    sha256 "9175d30c288f134f43842fef7452a9448b2f8eee6bee445cda2749b157785cae" => :mojave
    sha256 "c75d72dc246a5ba4be4cc12c27228090161be82703ce4d44af2e772cf2dcead2" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

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
