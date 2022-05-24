class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.5.7.tar.gz"
  sha256 "45f39b225616930091e1746c09520335dcf498fd9947f902a15074fbafe0637c"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a71e0062ca94ea01f5e3b8d77e2ee7999b11fd3861f81690735ee4dc9948447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a2513e149eeff2e443da0f29a8f58973eef359e8a9612e81d95ab6fe4f90feb"
    sha256 cellar: :any_skip_relocation, monterey:       "a687bd8cd39296f99fff39e0d113ea423a3f8a310a448bae467e98456da66a00"
    sha256 cellar: :any_skip_relocation, big_sur:        "68eac3629b44c7b77950814a4c6a92617adbc9fb971f585b5a99d7e4c6dc6727"
    sha256 cellar: :any_skip_relocation, catalina:       "b23d4b60cc64f468e932ccedd502effa7c076d92ba3cd03e54f8e30a516d0902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9623c411433ff1891ee2b2e7471ba28785e364f22ef82a7df65f0210de9b621"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "git branch: master",
      shell_output(bin/"ld-find-code-refs --dryRun --ignoreServiceErrors -t=xx -p=test -r=test -d=.")
  end
end
