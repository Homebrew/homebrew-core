class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-01-17T23-25-50Z",
      revision: "cc8758c88da31b95dde7b0b6997980ebfb8b98c4"
  version "20250117232550"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "875b1b9ff0dfe86d04b626e4906ed68c48b3537ada5a0502d0e973a517deec1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfbf167fee8b3b462ecbba858c5875897b834b99105dde6343a1bcd97a531273"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a48443062c4f598aaee4a1479611fcde246f91f62bf894d56c867bd15c13d68c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b44f2f19a97e37522ac44a41e3d7db89ab6325eeecc1cae4a03c52c1491f0e31"
    sha256 cellar: :any_skip_relocation, ventura:       "355a159ff3dfb61691b8b805f007c1be535fd1d77bab23247c57f63c31f53261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8cd99715de4de237af5ee41726fcf3b30ca477950075a8e48daa5ca7f6d9793"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      ldflags = %W[
        -s -w
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin/"mc")
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
