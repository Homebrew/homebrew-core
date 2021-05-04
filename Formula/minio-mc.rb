class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-04-22T17-40-00Z",
      revision: "4eae7ec7ed254d425be1a72151f9a1f60707f273"
  version "20210422174000"
  license "Apache-2.0"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4cafcc6a8dcfba05ebcb572ffebaddc477cb075db1259fedac5f2c03303fd7b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3b9bf30be936a05ea50fa04d06861cfc04bba6c3f6cfbb943958d9a1439aeae"
    sha256 cellar: :any_skip_relocation, catalina:      "ec9831679aaf37e35a8429d692d7c16a82f94530ead2566615c0a8213bd3576d"
    sha256 cellar: :any_skip_relocation, mojave:        "dfdc73bd87522f919bcd45b1dcda2b91541cda7ff5cb529c0e6643f98bb3ec89"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
