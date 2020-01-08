class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-01-03T20-33-14Z",
      :revision => "6d1a41458bdb1eda4d7064af16dcf4692e2967bb"
  version "20200103203314"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c954321067f038dad973000f708b9839b5c72ceedceca3a41b66e05d2e73dd9" => :catalina
    sha256 "723d75e8ee434212b409f186964f98ab5a0cfaa4636e34d23daef25d871a1c61" => :mojave
    sha256 "06013c117dbf0482e4efc71c478e1ddc53139e45e6f8325530cd413e9a1cec57" => :high_sierra
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
