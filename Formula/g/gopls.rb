class Gopls < Formula
  desc "Language server for the Go language"
  homepage "https://github.com/golang/tools/tree/master/gopls"
  url "https://github.com/golang/tools/archive/refs/tags/gopls/v0.16.2.tar.gz"
  sha256 "be68b3159fcb8cde9ebb8b468f67f03531c58be2de33edbac69e5599f2d4a2c1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{^(?:gopls/)?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "223e48d4c467cede757b4b68014d372269645dbfb01b2bf9ee5be6f3db2ed24b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ba123574ac5e829f2cbc22e1d25ecbbde34b0a0a57daf1d1756d316dc844425"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ba123574ac5e829f2cbc22e1d25ecbbde34b0a0a57daf1d1756d316dc844425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ba123574ac5e829f2cbc22e1d25ecbbde34b0a0a57daf1d1756d316dc844425"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef67a637954689ad1c05e3eff2fe276e0e0e25ab7c8e9b717d3c15e9bbc40f1b"
    sha256 cellar: :any_skip_relocation, ventura:        "ef67a637954689ad1c05e3eff2fe276e0e0e25ab7c8e9b717d3c15e9bbc40f1b"
    sha256 cellar: :any_skip_relocation, monterey:       "ef67a637954689ad1c05e3eff2fe276e0e0e25ab7c8e9b717d3c15e9bbc40f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3af2df59d74264cce09c7e6841526f91c600ec34b178fbd17162933747058d"
  end

  depends_on "go" => :build

  def install
    cd "gopls" do
      system "go", "build", *std_go_args
    end
  end

  test do
    output = shell_output("#{bin}/gopls api-json")
    output = JSON.parse(output)

    assert_equal "gopls.add_dependency", output["Commands"][0]["Command"]
    assert_equal "buildFlags", output["Options"]["User"][0]["Name"]
  end
end
