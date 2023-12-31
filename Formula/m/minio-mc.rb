class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-12-23T08-47-21Z",
      revision: "c27ddd4adf534e671b3dd629d1ccf2574760c784"
  version "20231223084721"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e094c5643415ba6293a6b86aa7c00df805df87aed635e3f6f1a9b4664f9d36bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51fdcdb3dc27dd2309c62a88949f36362ac32283a56a881f3e03be58c075e0ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c411892a7cc9912c9ca1ed0b786594c48b6796b0a9056b4673986d238e2f6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d15d2d45274f2028c0821fc6e6498a13a42f5aa7cca974520d625b12f76df34b"
    sha256 cellar: :any_skip_relocation, ventura:        "524acfe3058047d4e5347c27d9f948c5f22fe3d49e1f676a5ec9c830a139e23d"
    sha256 cellar: :any_skip_relocation, monterey:       "3809f2d76d4f6065880eebb7eb0514272c84988a642ebd2dc88832c7777a8385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae971e3347a8293ac6f197d65f61ba284c550cdd0f4f6c35a6d842c83b2bf28"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
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
