class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2022-11-17T21-20-39Z",
      revision: "2770f13a73c5e98ae1a0665c76cf099f5f578a13"
  version "20221117212039"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adee0ce9be6c6fdc24dc54d592537eb0b9c66692828de77e201ca1703c8cdd08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb991b8ee09f96d23fb2fb63b9c38212b8978a258f225ba768070db1876f6053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b074e81e0625e1c783e14a47625348ddbe5b9a260f73cc89e868aea7dfb6b69"
    sha256 cellar: :any_skip_relocation, ventura:        "baaddcf50d88cbf6223d9ff3e55679110161053a30122ce3f363dcf3b0ed54fa"
    sha256 cellar: :any_skip_relocation, monterey:       "c713513802a8b54355969c70db15fefdab004682eebfdcb7159ae148b970e86a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2bf0a742a014b83d27b993fb365da5fda0adea8e82f2d50b5216a7fea365a06"
    sha256 cellar: :any_skip_relocation, catalina:       "925dd23378b5c49dfbe6752147d0a1d61b1f1e80e7fe01537be875f879194627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4aeacfe7694f1d996ad8542f95ffb147af62a82edee940404a7e979302908bb"
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
