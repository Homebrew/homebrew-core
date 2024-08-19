class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6462153e549124a70660eba2a47072f261dbca381639d929d1b49d1c08692b60"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09121d4eb2a43298676eb503ff5e468404e5875c283c3031cdf6bda94b191204"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be6b4464439ce42b861a02c26ad20ecc12133118d3f0168bc9a3959401f9cdc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "777bf8e85cfc6ea21f2643ec421743f474b39aeb0c0fcc4bb1b944d46b5699e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "33f451d6afce138f071db6db0dc42e806d4aabb977415805c35f44e7d283b0a1"
    sha256 cellar: :any_skip_relocation, ventura:        "7003bc96d8db291f8f1164384738345db19fd0341db390dc645b0f367d3a6fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "d839959646015d2390bc920ef0a7e2e644bcd3117303ab9ba6929df261c9aac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b075bfb4848885c7435c47241fcef585930efa5e5f2e81b08f28361feca65b64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
