class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-10-04T06-52-56Z",
      revision: "eca8310ac822cf0e533c6bd3fb85c8d6099d1465"
  version "20231004065256"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e573aed47004d09717bd39f6ae384c517ff4cf5abf677d512cba1c81d193810c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "486ef0f55c83ce56c90303e30ea368ab6b64032c2c4e1752588054462295ce4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fc2158f799640f3fb89183dddf822cace6193fd14f8cd24d2bb032391a0e68"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6ddf281e34c8e42d182f5cf104aca11e5411440acc0f80f85e9cc92bbafc9df"
    sha256 cellar: :any_skip_relocation, ventura:        "40e091a6bf78920a698abc69decbad9124b5c0628596c074b651c4e5a3e34795"
    sha256 cellar: :any_skip_relocation, monterey:       "e1f80b500bd8a6e0c047e180afd99e9ca55005e9caf10ca10ed27a3775a6ca71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22802ef8a4683a7ba1f0185e2e68ede4234d31ea9929f74068c10cf4bd24ea3a"
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
