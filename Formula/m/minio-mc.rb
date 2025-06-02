class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2025-05-21T01-59-54Z",
      revision: "f71ad84bcf0fd4369691952af5d925347837dcec"
  version "2025-05-21T01-59-54Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "630f19beffbfa994ca31f2eef0498955a7e6cc35ea214ff081e93e1746bf154e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea0851368cdef34b9cedcefa9b454e2d562e2227c56c903c023f6602b187660"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "432dead830fa5b3a236282807afebdf17441aabe9dcaa62b36e8ecfd69518d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07d52a6b3f2166c70ea7810aae5a200eedf24ad38a53d05f608c9c800a5a4d9"
    sha256 cellar: :any_skip_relocation, ventura:       "110853898578739890643493d445b9abca7578ed4c23624ed7c5f11a1bba872e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb12416b10fac99a384caa6593cae15d691257f532f0ccc478b4f66fb5e99659"
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
