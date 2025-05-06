class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "b68b924ee8a8bea41a8508824555455a001af48df3f1f60d7f4fc55b2abe7188"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5755722b1e46c3e058c2a42dca4e79a4602fcaeb69be97bb8c0b01193b23b9f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5755722b1e46c3e058c2a42dca4e79a4602fcaeb69be97bb8c0b01193b23b9f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5755722b1e46c3e058c2a42dca4e79a4602fcaeb69be97bb8c0b01193b23b9f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbbc2b20c13dee5e1d75420bfb443086d049fccd84651fd79ceb3a4092a3c19"
    sha256 cellar: :any_skip_relocation, ventura:       "7dbbc2b20c13dee5e1d75420bfb443086d049fccd84651fd79ceb3a4092a3c19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494b0d8df7cf9b9fb421600b8e16d4dda2f06862733d46bdf3409b72f6f62f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56648b3a5981cbd825079b534e4a3764eb2606bf251394a7926bc7f4f22b4f3f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ls_lint"
    pkgshare.install ".ls-lint.yml"
  end

  test do
    (testpath/"Library").mkdir
    touch testpath/"Library/test.py"

    output = shell_output("#{bin}/ls-lint -config #{pkgshare}/.ls-lint.yml -workdir #{testpath} 2>&1", 1)
    assert_match "Library failed for `.dir` rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end
