class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-02-28T00-12-59Z",
      revision: "5fbe8c26bab5592f0bc521db00665f8670a0fb31"
  version "20230228001259"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebee4cc46a79e11e68f8ca667395ad5b89aa8b36e0bbf3181f974f061e2671af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77bbc8d480ef4a68f9d36cade024296685aee2769f7b1b3781a03406ea55515a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff398257822d628b01570b2d5fb4b1d8f88223309bf2e742e37c5f5376c71fbc"
    sha256 cellar: :any_skip_relocation, ventura:        "071fa8922229a794fcc7aa04d650a63d78ea513f1303f341dd75b9ee33d09e5d"
    sha256 cellar: :any_skip_relocation, monterey:       "eeea95e86a6ff01b37b80a02899272bbd01b9ad4d8cf37203c9e9c8ff450128f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a9d33e6091643fc658af490e51a343df6c297ed9a37fe8ada3ff781639aa7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cabd7172267920286d7c33df22bb9e1b0d8973ec4f7fb0393927695ea882fdb"
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
