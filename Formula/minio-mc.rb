class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2019-02-27T18-44-28Z",
      :revision => "bd5372f165a5f5fb59aab1b68c6d4c693e9de282"
  version "20190227184428"

  bottle do
    cellar :any_skip_relocation
    sha256 "30889209d94171a492c4d7b3425115d39741f6e173d0a498eec7fb99918bb879" => :mojave
    sha256 "8d647ff8564e4aa38b366b5e9530819c5f8ff943c3ea69756bb1dfed545b9f28" => :high_sierra
    sha256 "dd6f850d896388d43d9ff7aa0aa92d8be935dc40cf86519ecfcc19d0b6d5b82e" => :sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/mc"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"mc"
      else
        minio_release = `git tag --points-at HEAD`.chomp
        minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        minio_commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/mc"

        system "go", "build", "-o", buildpath/"mc", "-ldflags", <<~EOS
          -X #{proj}/cmd.Version=#{minio_version}
          -X #{proj}/cmd.ReleaseTag=#{minio_release}
          -X #{proj}/cmd.CommitID=#{minio_commit}
        EOS
      end
    end

    bin.install buildpath/"mc"
    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
