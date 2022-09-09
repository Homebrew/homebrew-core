class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.8.0.tar.gz"
  sha256 "4dcb7a817d4bb84827541e059a8dff08c1588a0a5a8980ffabe7b6277b501553"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc624c860369535b3d26635d31fd3ca82ece6367649aa8ab5c378cc9bb7f17d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d0a447e27867b1c82d1efa594abdad64d73f42896a897cb03f4f19a28240d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3797d596e2e8af65c83923e1449f91cca9b8aa90b3f48022244ce21b9610f2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "75fee49a1583b0473ba74e7f1c12a27c1c00dd656f7e7ff97d027ee0f6b76b99"
    sha256 cellar: :any_skip_relocation, big_sur:        "25912afb3ed43c8297560880ee82cb194318c1d66a21e774d91c6081ae47b490"
    sha256 cellar: :any_skip_relocation, catalina:       "1d917e54ba9f10d8575e442e21fdbb75bc1b8240bfdb1baecf8db15e20721ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da4fc01c39b49a8621c1bbca02deb4659f9a663ffe1bd72884e5e2ee749f1b2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ld-find-code-refs"

    generate_completions_from_executable(bin/"ld-find-code-refs", "completion")
  end

  test do
    system "git", "init"
    (testpath/"README").write "Testing"
    (testpath/".gitignore").write "Library"
    system "git", "add", "README", ".gitignore"
    system "git", "commit", "-m", "Initial commit"

    assert_match "could not retrieve flag key",
      shell_output(bin/"ld-find-code-refs --dryRun " \
                       "--ignoreServiceErrors -t=xx -p=test -r=test -d=. 2>&1", 1)
  end
end
