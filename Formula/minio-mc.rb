class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2019-09-20T00-09-55Z",
      :revision => "57a9c6fab2064c30a036c1ff7f044f0be483cd8d"
  version "20190920000955"

  bottle do
    cellar :any_skip_relocation
    sha256 "bed676808d7988eefcd91fa6946a2bcf6f6e7e40fc020dc3dda7a83eb455bfee" => :mojave
    sha256 "33abac54af7585e3b5cb903a826f68972495b08ab2bdbf0ab6859b2755c0e7b2" => :high_sierra
    sha256 "4dfd207344c40d10fa1c47a36621c38a315a049ff3ee0095e9d52695eb5ae638" => :sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/minio/mc"
    src.install buildpath.children
    src.cd do
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
