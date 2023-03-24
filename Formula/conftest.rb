class Conftest < Formula
  desc "Test your configuration files using Open Policy Agent"
  homepage "https://www.conftest.dev/"
  url "https://github.com/open-policy-agent/conftest/archive/v0.40.0.tar.gz"
  sha256 "87049107032bc927baa88b6c06a935f3b8d247b936b6e1c2d210b0122de992e3"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/conftest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef547b97e319bc8622bb6593e5ca996f646cb280866dd3d6a8a3a05c8b87af90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef547b97e319bc8622bb6593e5ca996f646cb280866dd3d6a8a3a05c8b87af90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef547b97e319bc8622bb6593e5ca996f646cb280866dd3d6a8a3a05c8b87af90"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d99ce44dd98e94c7f518bf3ee173d1c0c30d6012f589f4c9c65821d1f08a5d"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d99ce44dd98e94c7f518bf3ee173d1c0c30d6012f589f4c9c65821d1f08a5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2d99ce44dd98e94c7f518bf3ee173d1c0c30d6012f589f4c9c65821d1f08a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d7dccb3b2e34218ae7353864b081a9d47820f7c87cf63b7d927daaa6b3abdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/open-policy-agent/conftest/internal/commands.version=#{version}")

    generate_completions_from_executable(bin/"conftest", "completion")
  end

  test do
    assert_match "Test your configuration files using Open Policy Agent", shell_output("#{bin}/conftest --help")

    # Using the policy parameter changes the default location to look for policies.
    # If no policies are found, a non-zero status code is returned.
    (testpath/"test.rego").write("package main")
    system "#{bin}/conftest", "verify", "-p", "test.rego"
  end
end
