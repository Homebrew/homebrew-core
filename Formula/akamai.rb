class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/1.3.1.tar.gz"
  sha256 "49ef54c474bd2e07c31516ac94a65d532c95499002a1ce0565d14702bc960a99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "9cc4acc54d8c5fbc15161c248d5bd04adcc09b10652c2617b27a84bab09ec436"
    sha256 cellar: :any_skip_relocation, big_sur:      "f9fd6cd269dd353fdfb0bcf860a1d7beabf5a63e1c273f7e7b71fdfccfdbd1df"
    sha256 cellar: :any_skip_relocation, catalina:     "413bde847fd271e49cbdddf8c5743279dd80ac867e91253674f3ea0ee81089ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5d4f64f123d54ef676aafac3d51c4fbfe0c063d65d80aca3a340147613647fa4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
