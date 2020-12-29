class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.11.0",
      revision: "07afc7d24f4d6d6442305d49552f04fbda5ccb3e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "799234d0fd1db793475b5aaa33436d7751e9ea59ef0bf63e383a977f2e3c485f" => :big_sur
    sha256 "204d84aeb776dda39f9ab49fbbc03a1b4154db60503d181ba89df7739072dc00" => :arm64_big_sur
    sha256 "515be0f1647600a652fb18c7ca2eae45683e9e22f22ef7a8cfa0257e05ef6024" => :catalina
    sha256 "d785e2a6fb3cb2a03db1a83ea1f5f2105b6dd0b254d868b7b8950ceb8910c97a" => :mojave
    sha256 "743f8a5be5aa6dc79dbbd7f44b5cfe1726862c865042d22183d522c863994e7f" => :high_sierra
  end

  depends_on "go"

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{Date.today}
      -X github.com/magefile/mage/mage.commitHash=#{commit}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
