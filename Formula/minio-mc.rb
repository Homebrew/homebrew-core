class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-06-23T18-12-07Z",
      revision: "dea3058aa18ec6c65b821a1726a42d44d118a5ee"
  version "20230623181207"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6ad1dcdb1723ca2aedd4928845974ac37468b8ba474306742b8dadfcdde701c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6be5c950bd62e31fe9b21850f081333b87d559a53cc3a220861553a5d3b8ccef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb86f00bb5de753282efc4ad717632d9bcc0ad878fd945672da977dc6740ad5"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6eba3899afcd76ec7f313fbfbdae170366ddf11568b1d87069dcc7f12c2d84"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3951ce78b3b97b18c438706cb4b87481f63d9205c279a198b50d1692a2a770"
    sha256 cellar: :any_skip_relocation, big_sur:        "faa29860ac26bd8af01be70d58d2182bd5a8b35eae99eca2f69818d975879624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "198ec2564895cd7d617c9fe45691b5133f87f3fcd02d05a5e5724aec241baa24"
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
