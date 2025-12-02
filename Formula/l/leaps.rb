class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8335e2a939ac5928a05f71df4014529b5b0f2097152017d691a0fb6d5ae27be4"
  license "MIT"
  head "https://github.com/jeffail/leaps.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "103b30a47094dfd56795de6c70cf5baa989711429147f6db55328529aa2e8823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "43d3cbf4a3539d7309b2d12ddab84541f1360921b6d67d7b727096998329d952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bfac2abd2f5b64411fce7e91201e7680047747405ba719836d78fb74d8004c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cadf303cd8afe3342acaa332833315822118c46e5a7bd0e2ac7f03d839c9b529"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50cb3d2e58261495fc33607825dade069b92d7f6fdb70cae7f1052182895d34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2602cc2c500cc446b5ceb72ffbb6dab1d339ffda72b5be20c73e33a432378e3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "da2312d241d0de20edb44ec000d71972e548030ff9d47ebceb3ed5d7d8078487"
    sha256 cellar: :any_skip_relocation, ventura:        "de49d3372e65ed4129bbf915d3220cd88a4e5bfe0ee468702d05cdacc85174cf"
    sha256 cellar: :any_skip_relocation, monterey:       "2417b908a0c2934b3d68ebddfabcdc2d59dbe08ba42d2521a66f107af9a74e98"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ed65478fa14879ff6c24e7e6710d09a8143fe33aad4f8f353bb4ab91e393824"
    sha256 cellar: :any_skip_relocation, catalina:       "3b5cbe1f1da86d1cf1a3603fd6b0697a8fbe3bdffe6083dfc5b16c60cb5c3798"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b7dc2241a2ae6660fa4d19bca4286fdbc3fbca175fc76706dec413a743bf8522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1f94e5c2315b93194e5b5573de8ac9d57fe7b791e20538839df29b940d4824"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/leaps"
  end

  test do
    port = ":#{free_port}"

    # Start the server in a fork
    leaps_pid = fork do
      exec bin/"leaps", "-address", port
    end

    # Give the server some time to start serving
    sleep(1)

    # Check that the server is responding correctly
    assert_match "You are alone", shell_output("curl -o- http://localhost#{port}")
  ensure
    # Stop the server gracefully
    Process.kill("HUP", leaps_pid)
  end
end
