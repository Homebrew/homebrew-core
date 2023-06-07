class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-05-30T22-41-38Z",
      revision: "ca1d00741b954210c264effb576ef1ed8567722c"
  version "20230530224138"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb430591d87ab2791883ea7109503b2f0e3005c4cbb4284f16eb9300f2f6daf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d86e7daf702fbb8567e018a6dfd8fe56a1fe515d44f7549b6f39fb65ad31de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "142a7f384d5e134eaf91d44374545703de11cc334d1b9e1516867fd7839329f0"
    sha256 cellar: :any_skip_relocation, ventura:        "cbf4a8b62235deb6c09d34641712bb047f1151d5b37120e1291ccf595e8e3e17"
    sha256 cellar: :any_skip_relocation, monterey:       "03ca8a4c0dda5fc4f7ec52891ee5132fbcc6bcb8b107bdd7257df55fd8de3282"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1ae107f1ed0a90a1c7d1896a618f1f84ab4bfb67cfe3b938a8d64a4452389de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6611ade27df257233cee55f18a8406133e6de874039f21c593c80ce9aad61a4d"
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
