class MinioMc < Formula
  desc "ls, cp, mkdir, diff and rsync for filesystems and object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
    :tag => "RELEASE.2018-03-25T01-22-22Z",
    :revision => "da5c19848d1e82a24eddb453b01e83d4a0660de4"
  version "20180325012222"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dfcc44d9cf2b30919bfdcf86d65efbe81c293210ac33b114a94c06e0f0eda7e" => :mojave
    sha256 "1235f53d757d0c51ef77dbf3e1900ca7660d93b0f754972437ce1720458c511d" => :high_sierra
    sha256 "8a9c6456b0b615fab9dc2ebdf5601c814e370f0c14fff7431145a3a1a3af2732" => :sierra
    sha256 "b106e7ae5307d4f95b16968c3bf8d3959a69ace1ff5da79148a3a4460d0a03a6" => :el_capitan
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
