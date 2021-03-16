class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.2.0.tar.gz"
  sha256 "644c722ad7046e99a6e638105cc75ee616c0a5091d9979f8118ef9473f6d7e67"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "6ce7c1b2b58e3225295f90b5d83f4d3a7df4530b769ea44c716aaeec35b498d2"
    sha256 cellar: :any_skip_relocation, catalina: "e8c599f32b5f7a489cee4723d378661c8aa12fa7ed3f1bef5e15c27f39a8cf87"
    sha256 cellar: :any_skip_relocation, mojave:   "1d96850b0c979f5f351877977b7d06e5b26a78701a8993ad6366b229c15cae97"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args, "cli/main.go"
  end

  test do
    assert_match "Purge", pipe_output("#{bin}/akamai install --force purge", "n")
  end
end
