class LdFindCodeRefs < Formula
  desc "Build tool for sending feature flag code references to LaunchDarkly"
  homepage "https://github.com/launchdarkly/ld-find-code-refs"
  url "https://github.com/launchdarkly/ld-find-code-refs/archive/refs/tags/v2.11.8.tar.gz"
  sha256 "7d1c3bbd4789e3e9719ac609b7c7391982999fac63f4e3fb461238c544558dbe"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ld-find-code-refs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03a1c81635088320afaa1aa2146349d8da10b4af71a0e7d5177a652e6eb3b669"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef62325891d7cb33d50bdc065e420638d1320211d9cba8495703261e2dd26ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1807fb8ed16591d242e0cbac484dce64da619883159f90ffc9942e349c49843"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fe2e723ffdf88bcbacea40326fdba1657c5f41821a95a38a038da9b9899017e"
    sha256 cellar: :any_skip_relocation, ventura:        "b5e68d23544da211091e71da182d39ce7e5997333569463b3fe2619953c19803"
    sha256 cellar: :any_skip_relocation, monterey:       "f1be47e19090c50babefde9b09cebf35a1dfda51107d17affae62a9ec6cb44e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafeeba4c88af09233f8becf460168454673f8fffc45c7809b66834f7aa47997"
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
