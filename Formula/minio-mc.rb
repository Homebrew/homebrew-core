class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-10-12T18-12-50Z",
      revision: "3fe6778ee739504b169743cf43fa7b3010e05b99"
  version "20221012181250"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0009c0b600052cb137184bdc7462352b121bfb57cf3b77b216f68ec23526fe54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f2bd6ef2a3bb327fd64de81360ab594bfba358a921d575676fc779e23fcf6ff"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8b03d979f41a52d9d711be55f6e232d84390f2cb6a25b9a23a5d664750db6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aa5c37cbde43e6a88cfe5450157022990ec4a2c4e00013a7f6d2a27422b54f1"
    sha256 cellar: :any_skip_relocation, catalina:       "a46cd624dfeb299e51d5b6399939b0a4f7c5b2717819103a0c35baee5db14a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28d0844e811108d895db34d57751267322c9dbc0f0e0bcf49257dd6649f0b06b"
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
