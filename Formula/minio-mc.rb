class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-01T07-56-14Z",
      revision: "f73adff2383976d6b5644668bbd491b0551a1c96"
  version "20221001075614"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a46f6577326044e711a071bffac79977d6fd72d630591bbc419cbf065d8a3691"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fce8fe62622da93ede334090dd18f29dee457961a2dc2c5ac42229769f75d8cd"
    sha256 cellar: :any_skip_relocation, monterey:       "840325871003ebb34d4ded2d4ace52918187dc98678bf47301ef948e8a193b8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "154ca044009929d407654b451e9247e62edfd63a44729f542caa9646a13cdf16"
    sha256 cellar: :any_skip_relocation, catalina:       "7d397c7f03c4c6568126db71dd358c324314d720a97bc2732b0901886264367a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e8fe2bf161e678c005cc324d16ff6bafc810788cb15bb32fe7bd33ce618e61"
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
