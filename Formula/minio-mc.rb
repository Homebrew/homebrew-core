class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2021-05-12T03-10-11Z",
      revision: "7d142be7111bfc82960dc4a9cc5395cc5ca6e9c8"
  version "20210512031011"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e1bacdf8fc71984c80e67bdce7bbf72d7f923c57f81b5197ed8990a6129de621"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ddfe10e76beca2dae0900439af5875abc1974784f10e2f5ad5b646f5179f2a0"
    sha256 cellar: :any_skip_relocation, catalina:      "c0a0be1223d8a9d8b1cea5266cc6e397a8b8c3551264b5e01779bdfafbaf3c47"
    sha256 cellar: :any_skip_relocation, mojave:        "16425c99a50f5d0304fe8c14bfba0627f116614f999e79d2202c4e7d81bd07f4"
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
