class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-02-16T11-05-48Z",
      revision: "7d5e4ed56d9225d8b0ce0b36599dfc9e7e526652"
  version "20240216110548"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6679ff326c4cd35ebec46f192845dd4b641d7fbe54d00fc12b711338c9ef0ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ba45bed7f57f694e8c29dff31be673d066aa25a424b9d276d4122d3fd4333e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cae36cfa1d383f754cf5077c6c32cee19e146fbe1edc2f50a815a2696e127836"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3f7dc6af95928233f42dd1619e4cb229646cfe340f9329eaf09f79fd05eaf68"
    sha256 cellar: :any_skip_relocation, ventura:        "131fecb439d94f0b9a61f22f5ef6b6f321658e6180113ef8efc98791b9ddf858"
    sha256 cellar: :any_skip_relocation, monterey:       "50852675694ce41cf8fe9cc825a8153e181a80898722e473804dd4669e1043a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "157c0f9cdf1ecc203fa19226ff2aff7ee6916c7c69ea0400556c62e2540a8052"
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
