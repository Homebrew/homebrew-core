class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-08-28T20-08-11Z",
      revision: "a64491e101feeaf68735a20c204d06993ba531e5"
  version "20220828200811"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed6303ac72b370e47de7b5b52b024adafee5e2bf27f9a56266af67bfc8c5a91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b6299b4685758ff5e2ce57cbfeb8ba60b243a12e8979b0eb789561084d557a"
    sha256 cellar: :any_skip_relocation, monterey:       "65f0e8f0dabaef1d923047005b6da40004712121a289fb3a2dd7a9e3f163f073"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7a17197cc40ba4a33ff719ff9c84e33aea32fa0ab1d16e1fef78ef9ec1f8c75"
    sha256 cellar: :any_skip_relocation, catalina:       "a0f78c615bf7f0120121792f5c740fac8aeac3944ad602db8f2f199d5ba8db16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9698179f77fc166d6aa7ff593af2a2c89117734ca74690671538327a6a0960"
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
