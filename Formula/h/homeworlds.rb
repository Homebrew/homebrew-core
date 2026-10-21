class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ffbad58943127850047ef144a572f6cc84fd1ec2d29dad1f118db75419bf600"
  license "BSD-2-Clause"
  revision 5
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8fbdd9b444486de209290281698aaeec9bf3e5220a9db5dd3d37e674b4dd5813"
    sha256 cellar: :any, arm64_tahoe:       "8b43666c54c4fc0223b792a696da1a78c4d8c84d61599f4142adb4e5b77fc8ad"
    sha256 cellar: :any, arm64_sequoia:     "6b2094ee410a53953e6d12cce501ee7adca86cb7e3cde2fb06aaff038f7707ea"
    sha256 cellar: :any, arm64_linux:       "8f453b57e22aa6e74610a3fa64fa71cd91ddd52e1cd1f8117c9e6920752cd36e"
    sha256 cellar: :any, x86_64_linux:      "d17bc723913564e57e6cab33ad5c57a5193c95e7836c8306902eb193b0cabba0"
  end

  depends_on "wxwidgets"

  # Fix missing `#include`.
  patch do
    url "https://github.com/Quuxplusone/Homeworlds/commit/bb1a5d2395df4e097122b311c0009801107f4d3a.patch?full_index=1"
    sha256 "a133fb4bdeb4a5d2759a7257989089402e0ad84edbaed86780c26d47e58b8d55"
    type :unofficial
    resolves "https://github.com/Quuxplusone/Homeworlds/pull/6"
  end

  def install
    system "make", "homeworlds-cli", "homeworlds-wx"
    bin.install "homeworlds-cli", "homeworlds-wx"
  end

  test do
    output = shell_output(bin/"homeworlds-cli", 1)
    assert_match "Error: Incorrect command-line arguments", output
  end
end
