class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/v2.9.2.tar.gz"
  sha256 "cb8b802c9feb781d91e3dbfb3d4239f13dd9813e0b521d7d219badf6847bdf58"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "658420959c6280275d1b208b887a4011d59f7cff8699c85d241756b5a3718189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e4d95836a95a0daf68045f6fb86ed64417d23ec372717ec947fa97897a52d1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd067847f18771363ae0949af3783133de2fb9f32a53abd244205b7f94ac10c9"
    sha256 cellar: :any_skip_relocation, ventura:        "9001a86cf3118d657b7243ea2c1ac5d007e6c8d4ccbc899a5bf1b4e293906d16"
    sha256 cellar: :any_skip_relocation, monterey:       "27521120a2b435a0cec50b4d25a324e0c499ed4264353bafb1df9a716e44d4d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7173ec9a2021f3385e0bedbb6cb69048abfab9eebb555661fa709a67f3ebe9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba8b9e64e0bc8445c5412349f83d37a5fd58ea81669051683ffba951a4e4f799"
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
