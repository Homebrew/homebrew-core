class Cod < Formula
  desc "Completion daemon for bash/fish/zsh"
  homepage "https://github.com/dim-an/cod"
  url "https://github.com/dim-an/cod/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3d8ed6f284afcf4c86a2164e234ab7ff40c50aa6ab0bd892e59f8dc8aef02541"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cod"
  end

  test do
    assert_match "", shell_output("cod remove cod")
    assert_match 'learned completions: "--help" "--help-long" and 10 more', shell_output("cod learn cod")
  end
end
