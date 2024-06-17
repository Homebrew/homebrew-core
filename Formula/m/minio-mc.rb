class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2024-06-12T14-34-03Z",
      revision: "e7c9a733c680fe62066d24e8718f81938b4f6606"
  version "20240612143403"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71059e42ff43be06a62c0b4a51ef16ca37682438f8f77ba0c9dffcd07cfd7836"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6600c08c5946abef4cd403fae1210dfaf17124ddecda543d17058409fe60a26c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64090f41019d13253c48a4ffe4bcb7c881a14154fb518d24910a46c63431b375"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a3b35f2c54481b3c474d57570672729d6da55bd851bfcc96a9c504757aa8213"
    sha256 cellar: :any_skip_relocation, ventura:        "51b9ec55ed7262c90f3c0f72963f2940f8d6818c9090aa6ba469a28f0eb1c9bc"
    sha256 cellar: :any_skip_relocation, monterey:       "48618d34590ddd4c3a909f23a29b29a18107c7fcbb9a7231f87e01f8cd43ba83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57407e077d1c432e0a35d03eaf48a99a1cd47e733c12c6c2faf72e919cf55669"
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
