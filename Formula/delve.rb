class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.7.2.tar.gz"
  sha256 "c2eb068d5677e114286b38f57f784b3792dbd2db06743bb57217611a092b31f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c13d89ebcde5f9457bf26f8c6d311071a6823bd4ec1050e3bdddf87cfd3073b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d670046a35b7830ab19244566cd5bf8864b60ccb2470ddfaa79614166eebea8"
    sha256 cellar: :any_skip_relocation, catalina:      "f2ec21f4aa4dffc1c2d183596e439ad202a0e9907689a3f7936b4ce8ac39701a"
    sha256 cellar: :any_skip_relocation, mojave:        "a588cd42cc34a0ecc12b5771092e6516ccaca999c3e5f88c3f1c08251a438ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3ecac2084ad71d4d6a780da73c7d7c3965fcbc1c108e29cf56ff37c3458aad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", bin/"dlv", "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
