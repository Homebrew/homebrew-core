class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-07-11T16-16-12Z",
      revision: "add7b7b8814c7e7aeeedcc829724cae31d34ee7a"
  version "20220711161612"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736a1d688278c18b69916a7d373dd35aee6b11e31698c9409febe0de54422e8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a2aff662b77df9abb40169a3d17be862b6c18ddb64ffa127763cdd791a559f"
    sha256 cellar: :any_skip_relocation, monterey:       "0c484198b6c8e562670de06c5a81b110e899723d1cbb45e9402998cde485de81"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7536ad3325ec2f52ad7ae408632bc7b80c11ba991dd3631d7b88df7a98614ca"
    sha256 cellar: :any_skip_relocation, catalina:       "10e1ec13369bf3eee982f38bbd916d6b171761d429fa8b66fb09a39b9e7fe210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635a88bb26c50ee0937cdb2bfe71e81c7d6bddf694ae908c11efdfd4f4a31193"
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
