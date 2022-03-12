class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.7.0.tar.gz"
  sha256 "0cb52d5114b0ba9472e5772a8e7d6e033b090e61a1a6c6af88c6019e91159810"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bdf3a0fe253c9e91569d4ea5552778e08c2ae94c6f669074c8084db9dd8ea81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d791a7f78b2c9e30907babc745a2cf5b86702776e367acfa3d9c13590a606548"
    sha256 cellar: :any_skip_relocation, monterey:       "c6acb9c7bf9b8ca97bda93e19a6276e0dbbe2b24f896046ff27ddf797915ac1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "30831808f66cc0840e8894cc3cb44e48d4cb3ece950c07942b65b87a404fb7f7"
    sha256 cellar: :any_skip_relocation, catalina:       "f02781d672280a48020fdf6e10f758f3dd1c6328fa60c2cb93ad9f1f306d9040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6048843b90e9cec13c59a42680391df98e1333a0b3089859b25231aa791eb301"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    pkgshare.install "testdata/userdata.json"
  end

  test do
    query = "\"SELECT count(*) as c FROM {} WHERE State = 'Maryland'\""
    output = shell_output("#{bin}/dsq #{pkgshare}/userdata.json #{query}")
    assert_match "[{\"c\":19}]", output
  end
end
