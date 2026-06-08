class Has < Formula
  desc "Checks presence of various command-line tools and their versions on the path"
  homepage "https://github.com/kdabir/has"
  url "https://github.com/kdabir/has/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "965629d00b9c41fab2a9c37b551e3d860df986d86cdebd9b845178db8f1c998e"
  license "MIT"
  head "https://github.com/kdabir/has.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b408a2ce6764bf5af24c0cea31ae7cec23f953bcd686b652d4550e28d080de16"
  end

  def install
    bin.install "has"
  end

  test do
    assert_match "git", shell_output("#{bin}/has git")
    assert_match version.to_s, shell_output("#{bin}/has --version")
  end
end
