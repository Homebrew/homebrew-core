class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "8a686074e30db54f26084ec0ab0cd3b04e32b856f680b153e75130d3a77a04ea"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "687f2708ea80449698c7e397224c31bdefed92a3fb62129789af9696c903855e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff84cf136641fa9e4600cad7363ba236b6e61754febd1e1535221295ec433398"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f890aaf1aca1ef6bf208306efdecb9d0014d94814b7b8bc4630a147d159b90b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f890aaf1aca1ef6bf208306efdecb9d0014d94814b7b8bc4630a147d159b90b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f890aaf1aca1ef6bf208306efdecb9d0014d94814b7b8bc4630a147d159b90b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e5413553fe515154ec9f64b1aa8ce3818ae738a19c7f6b8e8e9a9996de8ca26"
    sha256 cellar: :any_skip_relocation, ventura:        "55c744422bc40db622dd94af14f64f0fce31dbfad1aabd536b0e2e6c4f8fe037"
    sha256 cellar: :any_skip_relocation, monterey:       "55c744422bc40db622dd94af14f64f0fce31dbfad1aabd536b0e2e6c4f8fe037"
    sha256 cellar: :any_skip_relocation, big_sur:        "55c744422bc40db622dd94af14f64f0fce31dbfad1aabd536b0e2e6c4f8fe037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b50b820851376d9360895b3376639d7a31e050fcb4709a9fb17fa4e8edc40c"
  end

  depends_on "go" => :build
  depends_on "pkg-config"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
