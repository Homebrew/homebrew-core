class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ffbad58943127850047ef144a572f6cc84fd1ec2d29dad1f118db75419bf600"
  license "BSD-2-Clause"
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc648ea7d7196a2067c452be9e0e4ba83500b687518bf6c120cccc9147e77201"
    sha256 cellar: :any,                 arm64_sonoma:  "7f0bfeb7524e5ca6ec187759fac9ca02b2a4f24ece3cfe8506d9d325530d8ba6"
    sha256 cellar: :any,                 arm64_ventura: "9b02997109618a53e50a2dd9dba793b98abe87ec60b2acd3efbf0ebc30ceeff1"
    sha256 cellar: :any,                 sonoma:        "12a6e003b2201f391a32e4e7329d56606fc61677cfe7c30ddf3003dc5d5eed47"
    sha256 cellar: :any,                 ventura:       "c1ef4ed10f9d30d5ac69572ce0ef0a9677924cecdcbdbdb3f520415675b983cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcd8d56b7c77a7a3817dac2aa1c006d8590d5e18fe67fefcdf47cb348c2b19f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3390b52f4c1be6153a244f3b396d54fec26315d710626c2fa9df90330e8199c"
  end

  depends_on "wxwidgets"

  def install
    system "make", "homeworlds-cli", "homeworlds-wx"
    bin.install "homeworlds-cli", "homeworlds-wx"
  end

  test do
    output = shell_output(bin/"homeworlds-cli", 1)
    assert_match "Error: Incorrect command-line arguments", output
  end
end
