class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-04-16T18-13-26Z",
      revision: "b00526b153a31b36767991a4f5ce2cced435ee8e"
  version "2025-04-16T18-13-26Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db913373f18141dec15e6a5cbd3057c1388a9f3ddfe9dbd31a99c352bc57ea53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f92466432bb6100f807dedc3cf4a6900fcbc0128d97884e8fa80348adae028a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81ca22774f09f03f0a7cedc97527fa0b64183a7b19d1ed41667a08d3c3fec07"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c9ffe52177ca726b66a160633b6ec98bcc3890accdf825842b6db181b3ebc4"
    sha256 cellar: :any_skip_relocation, ventura:       "2cba7fc036ecf5b7a7d7ef0c8bdc2343c3bcb70d7192f24a3782b5ecb69730bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2099365ee59980cb2bdc4cf738248ef7f75b5ae11316a0709991c485a5df966"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"

      ldflags = %W[
        -s -w
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
        -X #{proj}/cmd.CopyrightYear=#{version.major}
      ]
      system "go", "build", *std_go_args(ldflags:, output: bin/"mc")
    end
  end

  test do
    output = shell_output("#{bin}/mc --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    system bin/"mc", "mb", testpath/"test"
    assert_path_exists testpath/"test"
  end
end
