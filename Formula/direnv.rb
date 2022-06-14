class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.0.tar.gz"
  sha256 "d9bd6a78b57257306b45a64473d3302b0f274a3d2499e870d29f7a22a730f11c"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6555b52c58106d8bd62b977a81afcaf27c81d0c2766c64c22b80ca47605f671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a383e5b7b3e1e72cc82912a0c21e1db583f7dd3a9728275cc0398361d3a66dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "ac772724974989b255e2bc9697301f964b784f6f4d20a9248aa9b4483d80dd20"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad5ccf63f94ed6a549bfec10cfbcc34893491270a237cc2fde8cafffd5aae16"
    sha256 cellar: :any_skip_relocation, catalina:       "9836be8b0188a40f23030c7746ff559f7cb3e285bc864dbfc3dff46fc5150134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a461d580cce79e77f5adcf704746ee71e62cf5afe9af7640f4fc708fcd781357"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
