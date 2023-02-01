class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-01-28T20-29-38Z",
      revision: "2e95a70c98fb9c2629cd89817b8759bfa109a4d0"
  version "20230128202938"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "768724e608d6bdae8c2686b7ca4e09996b1dd4e4a1f46afa8b16860df53282d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93e0551be41511ced122892579c6383acbf3a6c5216ec463131bc40c8c967f72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4336c05fe6722d9b71d809633c5341ff3901dd756cf75a02e71dfd080bc4783f"
    sha256 cellar: :any_skip_relocation, ventura:        "7f8654f9782b5b281722de8644f4909f1b6d8dbc3b846d665beebfdf6d971bb4"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a0bc30400eed5881f891e718aa5a84c56356cf7e5fa174f61b9aa029d225d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b0d548760716f3577702f4f6ab6da55b1992496d74dd8a3181e19826bea1a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "248f52bae8249ab7efacb3a2c8b1e25f5d160fecbc1ba6949a6c81254d3e4148"
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
