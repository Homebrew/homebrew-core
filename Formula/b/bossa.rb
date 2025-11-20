class Bossa < Formula
  desc "Flash utility for Atmel SAM microcontrollers"
  homepage "https://github.com/shumatech/BOSSA"
  url "https://github.com/shumatech/BOSSA/archive/refs/tags/1.9.1.tar.gz"
  sha256 "ca650455dfa36cbd029010167347525bea424717a71a691381c0811591c93e72"
  license "BSD-3-Clause"
  head "https://github.com/shumatech/BOSSA.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ce5af8cf28d6afbc05ee144e859c878eaf19ced4bdd3eac16ef67a0335f62abf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "72aece3647237751f8f18d1cc9af56dfecbc84652321ef43137eec8c47fd7922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7ca492e595832676559c6b646e3d702ddd46dcb0610bf8d03c225b49c6d4624"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2158f7a97081f5f80316164003c9081332974aef077205116c33a4aecd374baa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a2c2eb937b91821a9f6f353219287ef55b464b9cf7c1b856d886fb1497f0eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "374d82b1d164b7996887cad910472e9a9e58fc5eecfb8e61271e26059137727a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0acbe505207e5941a946aa5578011eb90c34feda27045e6bd311f0f18ea9f8d"
    sha256 cellar: :any_skip_relocation, ventura:        "d2c70106f28ae84a178b62a6f028eac65adf61baf48c6de1d2992796403eb6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "0cc5c9f5080c2066dde8ee2c4c9fe8d7d6fc251a89bc975e2fde2fc99399e10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa5fe3c981a324abb67a667253e2cfae1479b832e8a2d53ba615d99d3e0f0002"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b59423572bf2c379b9d72c7d10a21c5e7f3bc24c09fdb1b797f57e58ab4f87e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0621b561b15f00b336c30d0d91ab52ab59b8b6fab7c1a9fccb4faa287f65b52"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "bin/bossac", "bin/bossash"
    bin.install "bin/bossac"
    bin.install "bin/bossash"
  end

  test do
    expected_output = /^No device found.*/
    assert_match expected_output, shell_output("#{bin}/bossac -i 2>&1", 1)
  end
end
