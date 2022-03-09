class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.6.0.tar.gz"
  sha256 "7064e271c3dcd5913f26ed45c365731c4a2b903378e2731032252f52a662ddc0"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1296d0f96bf7c7b795c572e339b2c625e1733f17b4d54d350e1f41b55322a800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62c0ff64941bfb83698fd634ba61d15f6c3178c7a59413e92dd2a8c75db29611"
    sha256 cellar: :any_skip_relocation, monterey:       "2700c40f4ebf8d320cf763bb956950411c08e2c106a6105798e313e5b2b7170e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c92f0f80472e6a35c052af88c16847294914774a43fc1fc3df3293c55880a921"
    sha256 cellar: :any_skip_relocation, catalina:       "d2826e749ca560111d957328020e41241fc04ee93d302cf032df6e1f8fe261b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512f090a037575410fde7514a7bce531db7534cd218dfc22ff214d49d36e449c"
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
