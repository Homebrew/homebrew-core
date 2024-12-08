class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-11-17T19-35-25Z",
      revision: "bb4ff4951a3e54bbee6ac75cfaf387c521e98709"
  version "20241117193525"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3c604c35c5eaf0b93a23aa4e06f413bf0c869819b361bc80c1ce1f5a11dc459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0823c35ec6c3504955337d800ae818875641a6c13d71dbcdc89370f15569fdc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3299e0a75780c2b90207e0021f8bfaf34cf5f07da5db30898354c3ee6ebc024a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2394c088f83a5c9e0e00793fda7cef164e645b86ba88c1afccac90a91b820461"
    sha256 cellar: :any_skip_relocation, ventura:       "81ef533fe5aaf45c89d1c1a1e3c2f026f6dbe8cf6fe67e7b506a5c282f5776ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff23baee8e97da4cb538df06779fb8a773eba8ee784101eb5ced386d72d8bd8"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      ldflags = %W[
        -s -w
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin/"mc")
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/mc --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
