class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "f7fd0fed6cab7e352bf6ca5e4d0dd5631d90ef4451e27787236ff4ade36de3b8"
  license "MIT"
  revision 1
  head "https://github.com/dragfire/leetup.git", branch: "master"

  # This repository also contains tags with a trailing letter (e.g., `0.1.5-d`)
  # but it's unclear whether these are stable. If this situation clears up in
  # the future, we may need to modify this to use a regex that also captures
  # the trailing text (i.e., `/^v?(\d+(?:\.\d+)+(?:[._-][a-z])?)$/i`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22059f81a610ed1cdd46afc875f5f7b5cb4fc4b64127364599072595e76fe714"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9f4a1549bef7b099fa1ee617bdeab8adcd92704e0f57a192b4e7453d6d3314ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "513dd96c791df2d3c9f728729b9003fc28c0f68d41e4d88a2f61a9ca56d61760"
    sha256 cellar: :any,                 arm64_linux:       "a77d5baf7559a034b91c4a67d1909e8c999677d3b486eeeb8d61113f4bc794d4"
    sha256 cellar: :any,                 x86_64_linux:      "d41f97a4bd9976ba073d810a8f93af802d8963c5e69e62110bc7b0969b58cb12"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    # The release does not include a `Cargo.lock`.
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/leetup user --logout")
      User not logged in!
      User logged out!
    EOS

    assert_match version.to_s, shell_output("#{bin}/leetup --version")
  end
end
