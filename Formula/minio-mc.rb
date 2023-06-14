class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-06-06T13-48-56Z",
      revision: "5e4ab1ec484fd398acbbda89cf17b381f8618184"
  version "20230606134856"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b317a9a8c762aeb7adf00dbd707d1e6458ff6ce184eaebec908bde5ba483ed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be322d5d06c5342952a664aa056a0f14582be88cb4e9002de870c6a91636b689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07de9284e8febab6c85e2f018263b7881c45fea35cba6e5f24ab050278b83f62"
    sha256 cellar: :any_skip_relocation, ventura:        "2cc298b4f355afaeb257cf4ba9c3591028d8d487e090f00334ff889bc35268f9"
    sha256 cellar: :any_skip_relocation, monterey:       "838997c23d6820d06cdc4a612aed39891284fd92ea32f90916f30d9cac621075"
    sha256 cellar: :any_skip_relocation, big_sur:        "868eae6060181f4ae9eba105024cb8ff53b29595306b6d3161a3631b7baac064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8460cd3a1b5c306cfb5b87e605b733894df0abbb8688445cccd5d0c149cb296b"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
