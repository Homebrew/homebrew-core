class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-03-09T06-43-06Z",
      revision: "1ec55a5178d701b1f4349930632c2b80884b46c0"
  version "20240309064306"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49424469b055fec35ece8f782fe1a281415f42871ecd7d95dcfc3ae205c5edb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "099f1328d9a7ea0fbec8d371d316218ba31f1f4ead448aed89c0cd3c38b430cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6420f8db06aa488ce9a7baac0e41e0f155fc4049c0e05af173dd399bbb896104"
    sha256 cellar: :any_skip_relocation, sonoma:         "3624f3623598b8bcae60acabdbb33576126c16d1350cb23b40468fb5ad4cb17f"
    sha256 cellar: :any_skip_relocation, ventura:        "a7934c7dd7db1f2e1540fa5c81aae9f17398f20ed7f5cad9ed7edbc1e3c6af8d"
    sha256 cellar: :any_skip_relocation, monterey:       "faeac865c6c40de2852b2d2860e18e59e7cd7719e805c995b8f27e8286a5f805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3c7f1a66d3cf27e4323f7ac31d98591e40bd37e37b3f26f8509f437f64db45"
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
