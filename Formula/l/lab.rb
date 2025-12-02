class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "f8cccdfbf1ca5a2c76f894321a961dfe0dc7a781d95baff5181eafd155707d79"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "433eaa1680f1b54c580ee3c240138d977c127d8e682ab81bd1e7942e9d291b0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5ad4754373780ae61c444bdfd9505479639b7d12a60613b3514e4f888335b347"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f11a5e58b8158bd43d1e4f93e4c85e398f6ba34308957b6e5b868c58d582cdb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eee3b3d1a309b0a61a5224cc1c13b0de765518b86015f6985a09347e86554b00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e8b682f99fd9f456d298e09d20521317f3b04248f53029d04ce5f8b3f3b75a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc2420cd4dd1db173333ff7c51530deee73b47a8fb5d3d36d60893dfd4c35ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "9806b52adc5a587c7992ca6e1fc86da47bdd71020c93d24c8d1ceb118d419fa1"
    sha256 cellar: :any_skip_relocation, ventura:        "5509e7f37eb68c9404e0f862fc87535091b7928a891fa38deede63fefcf314f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e3f02ef9e1748260a2ba5d9eefc79312b77f8d3ae223485aab7a025e7638e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f20ca44b476a3d6a3ef9a74047d4dd863403d72a427f1baa0dc19a9df5b33667"
    sha256 cellar: :any_skip_relocation, catalina:       "0ce4baa79e79a77dd30d3e7e839ef41c414329dc21ffa9386e74d7a0f69c7501"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "16b8efcf3a79c9b4f674d99af7d6931b4e7bb72d52616e56274c5dcc32860e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22981b2ebc3d41dd9b1905ab8f8f715d38d09c85f173e848473a8f731039653d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lab", "completion")
  end

  test do
    ENV["LAB_CORE_USER"] = "test_user"
    ENV["LAB_CORE_HOST"] = "https://gitlab.com"
    ENV["LAB_CORE_TOKEN"] = "dummy"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"

    output = shell_output("#{bin}/lab todo done 1 2>&1", 1)
    assert_match "POST https://gitlab.com/api/v4/todos/1/mark_as_done", output

    assert_match version.to_s, shell_output("#{bin}/lab version")
  end
end
