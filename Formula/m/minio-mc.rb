class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-03-25T16-41-14Z",
      revision: "7bac47fe04a4a26faa0e8515036f7ff2dfc48c75"
  version "20240325164114"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41cdaa2baadd4a8cfa40594b303c87d717db1f8c2700d48d803e8c1d3a1c4ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb35c74e4a34d50b4e6cad4735f97cf634739faad17ea834b0fb75cd3f90687"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c2e071dcd434e8df0419b0b998c71044ac7d10fbb1a3fbc42689bdd8abc118"
    sha256 cellar: :any_skip_relocation, sonoma:         "299471e7083b7a2018296812f7b979dac0c599037fce820820367057fbf40e6d"
    sha256 cellar: :any_skip_relocation, ventura:        "9df8a275b99e96bf3ead0b7ad6bda9fff2a71d0531f9799b36e7ac34d9c14494"
    sha256 cellar: :any_skip_relocation, monterey:       "c3409d5e3f20685440fee80577fbb914d4e85ac9452ced36c3153eb297218c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da7f5551e7195454f2dd761773caefcad6386e9876b55e21f194eb95867ed30d"
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
