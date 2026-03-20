class Errcheck < Formula
  desc "Finds silently ignored errors in Go code"
  homepage "https://github.com/kisielk/errcheck"
  url "https://github.com/kisielk/errcheck/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "703cb23f19976fc71dbbbd599da1788f686db6719bd07e71bc76476b705c09de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89a733ce92b2486256c82d329c5d5ecf85d1ee8bf375077010f29d70e7b79c74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a733ce92b2486256c82d329c5d5ecf85d1ee8bf375077010f29d70e7b79c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a733ce92b2486256c82d329c5d5ecf85d1ee8bf375077010f29d70e7b79c74"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8c7df6ff08b34da4fc9d7e3867edf7863f033dc17e2c92ae4104069f408c9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b85e11602fe5e6cdb6c945fb6769bcbae51f0f3c77945070f9b08f5a2faae98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dce2d4ec61d9c62e81504c021b8d84146d377921f755cff16fd6a188a95502f"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args
    pkgshare.install "testdata"
  end

  test do
    system "go", "mod", "init", "brewtest"
    cp_r pkgshare/"testdata/.", testpath
    output = shell_output("#{bin}/errcheck ./...", 1)
    assert_match "main.go:", output
  end
end
