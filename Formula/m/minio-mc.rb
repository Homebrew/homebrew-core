class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-09-20T15-22-31Z",
      revision: "38b8665e9e8649f98e6162bdb5163172e6ecc187"
  version "20230920152231"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4b218212e733b206a7aceccfd8cccbc6dbab04f4021cd8854bf79ec11881b52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b28b839e959665ff5873084dcdbbf60093981d9ceed260a2e956323e435c346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e65c30800bf520d906bb79901ec21182cc5bd919b2464d179d2f832633e54ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "3a131ac5729682fedddc3719a3a5f997255b429701719e78860a5a3bc97e005b"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc1dde46063ef270d497e90646000007100576f9aec52236b4022f54df0bce0"
    sha256 cellar: :any_skip_relocation, big_sur:        "66f2630a82c4f1b0cf783c55991dbfe2536ae55b1a17b0cc7a5d2402ebfbab8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4642c730b698035561bed8370dacb0dc8eb2a706c3841fe1f8b28fe3add3b673"
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
