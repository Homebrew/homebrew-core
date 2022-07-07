class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-07-06T14-54-36Z",
      revision: "81c4a5ad6ee47ff2fc264b9811d884984ae05f6e"
  version "20220706145436"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2350caa293d136d92ddb096f333698affefc67fcbeffe7176ba07c538df458f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0256550d144c35dfa14480369b1f7475c7e35d1fad7b91cdf8bba92ffffcb677"
    sha256 cellar: :any_skip_relocation, monterey:       "0bb45eb5d381c68876e3a764b5ce3100f081ab18aa8b97a9779c597f66854828"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cd4dbe85f8f8f4018f3992ae521173f50fb08d8071d2d49cf8bd17a2940aea2"
    sha256 cellar: :any_skip_relocation, catalina:       "75810ec942cf938069571c2d742e6bdddc283634d8faa8e229f3399c3060bc82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d4a9506f4afbced7605df8bfcf177d92dce7b8b9eaf6e606f1aede6059bdc57"
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
