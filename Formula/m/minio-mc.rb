class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-08-17T11-33-50Z",
      revision: "2c94b8d03979ed96a6379ecabc3435b271398efc"
  version "20240817113350"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d5431b1c2bbe9ae5916a726cb6ec817c8fe54429bca733dadaf0f697c061125"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c9ea2eeff621b04d1be7fdd0545e2ec4a778b7ac6385ee96b1f8ad23c14e23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4167012b7f69dd8ce6b0920cab60112325bde8fd3c776609745482799f5c4d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b05b824cba1013148ab0500a7b6f4cebc20cc5d84e29ea1c8961d7b59769b09a"
    sha256 cellar: :any_skip_relocation, ventura:        "277129acaf3d810243853010325f1f0759d42a7e3265a6d5f9b651734004dbba"
    sha256 cellar: :any_skip_relocation, monterey:       "761204fe6a58a58e6e0e6093256ff07ead6ae6549b4ef26ff7ab97c4fb6f4402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c95eab4ccad88e8c18690f6fbfdc30a8610e114030bc8086e7cecfb486c8397"
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
      system "go", "build", *std_go_args(output: bin/"mc", ldflags:)
    end
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/mc --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
