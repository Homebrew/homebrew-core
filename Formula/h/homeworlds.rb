class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ffbad58943127850047ef144a572f6cc84fd1ec2d29dad1f118db75419bf600"
  license "BSD-2-Clause"
  revision 3
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45a30b6daf394079ea156c6708a4831b7d3e752e56f5dd7e72c9e0986c56ff5d"
    sha256 cellar: :any,                 arm64_sequoia: "2dbdfe54a18e00ecdb5829d0bbef94016a8da5997badafe96b9520319885a18d"
    sha256 cellar: :any,                 arm64_sonoma:  "879e973ac4ce6c0e1db885f6c7cb9901cd5765ff9c418b2e71847ca0edfa17ae"
    sha256 cellar: :any,                 sonoma:        "e7711669fb6570ea72d2678ab9d6f424efeb17162f65417f86bcfcec336fe410"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1028e2b8dbb347b5a05fb84b47f80ef8c74efb4df461deb24f1e6a868e2fbe1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "029d312f8762b3accec75527e02af6d9d29260aef2b888b2d7190d1ca823794b"
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
