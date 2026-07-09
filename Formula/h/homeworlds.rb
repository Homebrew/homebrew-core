class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ffbad58943127850047ef144a572f6cc84fd1ec2d29dad1f118db75419bf600"
  license "BSD-2-Clause"
  revision 4
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b54d64aa4b808f8e766bd97eb686810c7aaac1a5a75e2da90df5b213459c6561"
    sha256 cellar: :any, arm64_sequoia: "a1a1e22ec2f4e99dc67ae371a0a51dc0fb423d01bc9fd667d88e00fbb730ceb9"
    sha256 cellar: :any, arm64_sonoma:  "8c10e66a2b4040f43af16401ab968aa9b1f7bd81082d231e2da508f0ed4db08c"
    sha256 cellar: :any, sonoma:        "18889c9eb4c4a7af491e70ce902b02f7072e0fa7f8d92b9c8f6c5c64b70ed7a7"
    sha256 cellar: :any, arm64_linux:   "b1f09b7e626a6703f98721fa0d0e820dc76fb701f0f38b983a37df75138191df"
    sha256 cellar: :any, x86_64_linux:  "1abe3d5dc91d0b2444e285fac0356e6fabee7e1cb61df19eadf45056c0e9cf15"
  end

  depends_on "wxwidgets"

  # Fix missing `#include`.
  # https://github.com/Quuxplusone/Homeworlds/pull/6
  patch do
    url "https://github.com/Quuxplusone/Homeworlds/commit/bb1a5d2395df4e097122b311c0009801107f4d3a.patch?full_index=1"
    sha256 "a133fb4bdeb4a5d2759a7257989089402e0ad84edbaed86780c26d47e58b8d55"
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
