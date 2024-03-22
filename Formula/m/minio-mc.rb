class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-03-20T21-07-29Z",
      revision: "9043bbf545d244b2dee9eefc5031d5dca1ccf78f"
  version "20240320210729"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2220c648480c12034b33add6e626d75754af627060fa67e9fda81dbec1c0933"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c531c2ce8dd1d5e18e8fc4ed03f58d0269589393b8d2200bbfcdb551609150"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4b9e8cc474a0ee58d58e31eb7c3968aeea8569f587be1432c448eb1d92521e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fa79a1a8c2a808856960856219d3a8ad6186724fee35748782c99db564351c0"
    sha256 cellar: :any_skip_relocation, ventura:        "e609244ab3c389e1c6c4736cbb456f04feb74de16131612c7fd1d56e2526783f"
    sha256 cellar: :any_skip_relocation, monterey:       "74424d834f89cc2a8e325519c4d88ec5ba0ca66a0fdb0eee83288a7716fd5f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "979a6d1d9ffa8c452be6bddd34135c9bfdb5a1c06ed8feacc7bca786b2c6e54c"
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
