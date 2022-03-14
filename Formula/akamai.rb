class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/1.4.0.tar.gz"
  sha256 "75772dfc70291d8310494a14a33589037d12fe4350fd5a3d1848777da76bf3f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "d9c38e6056460422cebccc1f0d05556e39fd2b9fcc6760eb12f06554c18c6c4a"
    sha256 cellar: :any_skip_relocation, big_sur:      "5f41b6da29dafbb90a707d65e3223b7fa00ebec63ec650e7883dcb0ec145c965"
    sha256 cellar: :any_skip_relocation, catalina:     "f60c0e63cfd19a9a72895657f8d97ce72542b88b6c1ff1a103c8166bf52e17dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8daead23033f6a276a0dfc8db04a3946521a9501210422580f4d8b18093e9121"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
