class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-10-02T08-27-28Z",
      revision: "ce0b4341521de16ae2172d42054bbe054f9c9651"
  version "20241002082728"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc972317d6666da21d749bb42b82e665c2997602d1061700e659fa7a044f6e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ade9c84cd39093ed1867915081d7563d02dc2a633c902fd94bba9772fcbe21c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2982dd0e2fd94b7cc55213c55afd6d3ba47edc9df61d197a0112afc70fa1157c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b0dd7e79b97984fdb5d0ab3d5d2a27114ed63e7c465aabee00699289bad4da"
    sha256 cellar: :any_skip_relocation, ventura:       "6d20fa4641f106237601ef7f5c4f6636aaa9e8acf8e9db1065c7f6357651b02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "231911af843ba28a287a5f7e3422a0c4fad6aa24886f6539603679f38cf7d4cf"
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
