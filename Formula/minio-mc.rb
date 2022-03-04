class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-03-03T21-12-24Z",
      revision: "f13defa54577bca262908e58aa4339969a8e3d34"
  version "20220303211224"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e75f19b301dd3715845dc933a470a9ccdc99be88deb87284a137dc0e33bf401"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e5964b84e6347045ecb7a35453318efa38ed516f091e0f5bf086aac127026f1"
    sha256 cellar: :any_skip_relocation, monterey:       "ddb18cc1b7fbe8108a0c2823aad6596b35905594b9c586c770799a90d597553f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a415e22e40b6099d63aa955ce417c2f5d8bbc4591828023da10e3c294cb934db"
    sha256 cellar: :any_skip_relocation, catalina:       "e98e502015657d6ea0e34f2952592e51d08ed9d676032998fe988a85ac516587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a992d8e67884b3a3d670ee1716c4bcf96362174084332d5316726d92cd73fed9"
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
