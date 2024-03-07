class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-03-07T00-31-49Z",
      revision: "33a43e9c6e924bc6ffe289ead600077a393e8056"
  version "20240307003149"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec820488d33b587261d5b2fce88a0efab65794692ed4789fd941f4361764e26d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "975e5300e893b41dc817289cccdb428d03c416e59bc6433785a580f8c53fe2ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0059d944a03a3b7acc724685df6334e993d728e05a322738d31a990bc51643e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b7b2982ef9755bad7b92a098eb187d19fc11ed43027b96a7b97108014aae4aa"
    sha256 cellar: :any_skip_relocation, ventura:        "e5965d871ae755a040fdeebae7d1b2a32c857d8122acdb40f90835c26c93e569"
    sha256 cellar: :any_skip_relocation, monterey:       "90f053c005d8d941462d5e87fab29de5dac73c8ea1d87fef5723165ea02b50bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65edb9dac41269256f498957ac02eabf3371fae7ba86c89f3d7a6acf43e25d9"
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
