class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.20.1.tar.gz"
  sha256 "b80cf1cd2d2a43762dcbb54b3b6e637822f3ad4aaa902721f72896f43855db43"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59f15cb7707b48fd76ddb5ee03267908fd8a14522a9f7ed3efd60123702a3f36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "851a423aff0dd98ac6414dba9a49622b1aaef76ce80bfa8a9e86fd386304018b"
    sha256 cellar: :any_skip_relocation, monterey:       "5923627181ccecb3b72654fb6e6d93757793c4b97925da0a072750a1b13f80d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9218617ba28d18a57caa7ded068fb9dbc374a40e5b8de25293e447879d5bcec"
    sha256 cellar: :any_skip_relocation, catalina:       "1f3a1d88bdf2edab9b676b7bb9021194801ee280bb2f7985f91b3aa2ecab0b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d524a9106856c5e1386faeedcd41f32c141954d76a7e8415593b1acc16c614"
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
