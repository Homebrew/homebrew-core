class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "ef776d0b91f9689f5e4812f6c04662f72a633b744f6a074d6f3951bb7c03cea8"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf43c52bcb83406c59990d117d64a9aefeb87beef11c1baa457c65f521da3701"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf43c52bcb83406c59990d117d64a9aefeb87beef11c1baa457c65f521da3701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf43c52bcb83406c59990d117d64a9aefeb87beef11c1baa457c65f521da3701"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff97aded0137863b07ed66cbfbdf94bbaa4ec421a0b097d7694d86daf2ad5877"
    sha256 cellar: :any_skip_relocation, ventura:        "ff97aded0137863b07ed66cbfbdf94bbaa4ec421a0b097d7694d86daf2ad5877"
    sha256 cellar: :any_skip_relocation, monterey:       "ff97aded0137863b07ed66cbfbdf94bbaa4ec421a0b097d7694d86daf2ad5877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c399aec052d1c3072bc23c4a5d9bf47b9bef2c77acf5c7d49ec5f4584b4a4f00"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
