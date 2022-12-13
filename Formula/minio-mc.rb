class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-12-02T23-48-47Z",
      revision: "a55d40caf78302f2a1ac9259f2b62650b5e526d2"
  version "20221202234847"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86390b22359443909c29da48ff7710cd0570831ed75ba713c276a587689dc8f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10c073d094483d77e8e87d1c4b12c135bb7bb2a4be9a7c7924a65ae27d71e874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f22f22cb70211536b3e4ee2ce590e285a721d9959d980c9dc52f9c12ad51cd7"
    sha256 cellar: :any_skip_relocation, ventura:        "4bc204b11b9fde83a09306bbc753be396ee84cdf75a179d2b79fd3fe946453c6"
    sha256 cellar: :any_skip_relocation, monterey:       "e986e7efbe968c5afa3a9f9e6654b67fd171b6506eaf68625134397c80ada2c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "acf40841f2940defb482e0d90445ceb711f1c80a9e08b2da52a65d0925628bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8230c79b5ea1981c7f825981ed4f688b095eda045aa30362fa05c6dde165f7b5"
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
