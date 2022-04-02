class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-04-01T23-44-48Z",
      revision: "5a3ad93ab94b8517528470269a4e0bb4f628f154"
  version "20220401234448"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28374d5fdb3f1a59413908f11dc03b620ba73ec10d0a9885a6c045c71fb67d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fde32136ea3bf7d777faa39806e34ed008c4724a4677bbaba27baa43ba39349c"
    sha256 cellar: :any_skip_relocation, monterey:       "594dd30824710836c773818b86738dd89a4be8c088cdcf76788f3f90c095dc3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84127559de066c88c4dfba3f6caec00f7e0f36b36774b4f182c135dd44f2257"
    sha256 cellar: :any_skip_relocation, catalina:       "d094522653ac2498bb92e650d0b28d2b12b825026ceb7b0be88e235a96ef0e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7522e811578df208e8411be99b7ae95e43636ff8e28012ce68141b8d684c9d"
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
