class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "94f964b2eba69e2df1f922cf83b193a276f6b64ac742bd65670fd07a307aee22"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6c5a750da0df61e3e3dd8140d8dab7988208a040e58e2bb8297764467b350ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19e720e66149cd632a73fce73bbb3993f4b278bef524e70c0b5d380d176b2151"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3575267bfac6e2915d6509d120b3997f35c319e1bf5a2874562775edd8aa34a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5558fc8b5d0bbd7309dd2985d957ad62e38631202a9473b331e70fb6d557086a"
    sha256 cellar: :any_skip_relocation, sonoma:         "08583e8b31ccca7ce40cd1928fdf650609fff73d4f7436389819ee6d9d529942"
    sha256 cellar: :any_skip_relocation, ventura:        "22c63a2140468e0b01a9d9db4905cc9a9111bb92e79e719d7924cc3f64ac5ff7"
    sha256 cellar: :any_skip_relocation, monterey:       "0864144bde8a0a64321dc4f52999cf7cecec52335653f17e81b09797315e7b01"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7a0db87b66cc64e9dc734bc917f8f02fb2c7bfd359ca20403845f5c565eea77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51793306a7358db7fddce5dcc2da3506e852c1428b8ec2470f4989f12e355e83"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
