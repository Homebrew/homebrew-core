class Dsq < Formula
  desc "CLI tool for running SQL queries against JSON, CSV, Excel, Parquet, and more"
  homepage "https://github.com/multiprocessio/dsq"
  url "https://github.com/multiprocessio/dsq/archive/refs/tags/0.18.0.tar.gz"
  sha256 "b61a811646cbd383e5f98bb8d2fc16c41bdb229575d90e84daa645512ef042bb"
  license "Apache-2.0"
  head "https://github.com/multiprocessio/dsq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0cee5d1a2830476bdeb10833298eaa3bbc278c1d121b81a921f2fa6c1fa5568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9ace387e84d1c3117688e0fe92e32212ca0398c453d5cf6cb356f8b416248ef"
    sha256 cellar: :any_skip_relocation, monterey:       "d6edb74c23082f6f4a8795343825b876e856881abb797756bcdd5270c5e634d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c0dc023c71ff8173b96a25956c7a0edafd996f137c48643c0dd55b4c3c3d995"
    sha256 cellar: :any_skip_relocation, catalina:       "911a42e8232a4a4cef6f070dbda411bc317febc9b11e6af56a92062024ddf67d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69b4842481ab6bc9ade3964aeb2956fa447dc51e7c9b4e87df4d0fe1f78afa43"
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
