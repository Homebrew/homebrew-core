class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-02-24T01-33-20Z",
      revision: "f17313e7ab892fa5c7561a63296b68c1691f9b2b"
  version "20240224013320"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5235928ac163b7e5e377d6d812fb5c232ede25fdbae9ef853727ea3685407aff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17bd73ff7cd99576e3b666b131955168ead953168b64117352b67da01646bab3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41d0bf17071b1bf8d419e36e46c9659f03e1d7005d5e23398c754f5c16e2ac7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b18f4054b8a3a12b8bbadc639c97aa51d9b585b9feeed44ad7acfc35053bd5d5"
    sha256 cellar: :any_skip_relocation, ventura:        "4ada6504095420e0adb785f908e0e5ea4c080459de9cae81176cf3a9c114b391"
    sha256 cellar: :any_skip_relocation, monterey:       "ca968dd81964db6001d34a9d3ff1355e2e3ba8fb254b0ade74fa6ec8cdbd6e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9267063238642c8323c659768f2b60f54f1f543faf0719059ef19881cca827a4"
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
