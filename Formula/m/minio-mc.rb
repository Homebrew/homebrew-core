class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-02-04T04-57-50Z",
      revision: "318e7070718f59198a9c6911f72e46dab1625b3a"
  version "20250204045750"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "392db2a57a97aaf9341641ffe7fbed2567f73685a44a6503c4c841beddb93800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42256aec7fe4480570a102666e076e647abf4bf110d07d239dd55723d0718289"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbee73974587a102b251a983402f1a925ad6bf0fc1409078a2ea874fb866664a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e11a57a2d60d7ee3f944e17e1680ab79cc52c8c4e3cc15497563331415d7f41"
    sha256 cellar: :any_skip_relocation, ventura:       "2ab2b341b4ead14be48241e832c229aac664707a4f6a10ae63948895baa4e62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55db2129fdc195125c09f9916565ca8d05fc824c9dbc348f617b62ec5e9c574a"
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
