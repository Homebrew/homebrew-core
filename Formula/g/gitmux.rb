class Gitmux < Formula
  desc "Git status in tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "c6a01faa5372a8c4ab24bc3a2c9665a9f430c45c79b175c1510388433637ca72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d74731881efc66465dac299a3bcb6824a90a5fcd4a7e0ab08997944e6e30d5c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0b068346b79e8a633b8825364da40f50ad71442da70bfc16f19a3e64c3bb632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b068346b79e8a633b8825364da40f50ad71442da70bfc16f19a3e64c3bb632"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0b068346b79e8a633b8825364da40f50ad71442da70bfc16f19a3e64c3bb632"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d3c91091767b588839c979566d546c7271219bf13b1cb1793e2b85f27a273f8"
    sha256 cellar: :any_skip_relocation, ventura:       "9d3c91091767b588839c979566d546c7271219bf13b1cb1793e2b85f27a273f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f06b817740cbcb1a2ad513713260c9c099350a975f8bc103c6dbb29e2953222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6022ed1868db6ff27a2aa65f499edd13463265470fa37c6816065a76c6f7636f"
  end

  depends_on "go" => :build
  depends_on "git" => :test
  depends_on "tmux"

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitmux -V")

    system "git", "init", "--initial-branch=gitmux"

    # `gitmux` breaks our git shim by clearing the environment.
    ENV.prepend_path "PATH", Formula["git"].opt_bin
    assert_match '"LocalBranch": "gitmux"', shell_output("#{bin}/gitmux -dbg")
  end
end
