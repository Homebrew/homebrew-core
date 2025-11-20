class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "e3b798d89138fdbc355a66d0fc2ca96676591366460f72c8f38b81365bebe5ba"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20c6354746bab0413fb7471f2803bd16834ff63588906115f73c137b71cc60f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bc9a055bd7ad8170b2779875eea4d07012fc5210b0da9fb304ee49ab75229a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bc9a055bd7ad8170b2779875eea4d07012fc5210b0da9fb304ee49ab75229a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bc9a055bd7ad8170b2779875eea4d07012fc5210b0da9fb304ee49ab75229a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cddf34e9ad638380806a0805f7b2433e0222971046bb76d1abf099a8b12ee441"
    sha256 cellar: :any_skip_relocation, ventura:       "cddf34e9ad638380806a0805f7b2433e0222971046bb76d1abf099a8b12ee441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b762bcafcc18f90c82476ca1a077fb9a7ddf6df2da627b680832b91c25f20b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8a14521daabae09419dbdd267df3598fa07e80fc418d2512a551807b26601f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildDate=#{time.iso8601} -X main.Commit="
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotify version")

    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
