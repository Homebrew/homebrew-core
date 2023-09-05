class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-02T21-28-03Z",
      revision: "e2056fb057897a515d2cad25aa461f5dfd32695d"
  version "20230902212803"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c59ddfe2d1c324b49243a220aa81d04c7b9ac99cc36f516e622ce15e714cc71a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f2a01d303b43f88fc897af73068a686b5b7616af9ffdd0994871854efd045ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8465c42b46a94cb677cc5627c23ffab3332c1ebc7eeb68947c4adca21c7c3f98"
    sha256 cellar: :any_skip_relocation, ventura:        "d43a8d29a5561f5bb4241f30f4fef9e353640a7b3c481c3ee9e3f1142247e09d"
    sha256 cellar: :any_skip_relocation, monterey:       "9ec9100088c33a1f8f69e73ff589abe1b1e6550c3faa69ee434031bf2f267686"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdb2d0c7dda5e45021bd4e132e5aafe5219143d84cb19f943fc38a07f1ea091d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f7416bc26664f8245c7b0212da4d6042596b6ef4cfa99c3136daa58594487b"
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
