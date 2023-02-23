class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.7.tar.gz"
  sha256 "ff634377e480affdde9c603b696ce103ca59ec0c3dfe604e54ac37301a60b250"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e708f804442c6420fc7f333be96f060ed78aeb459b05d73dbde11693837c0e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "402b85d247dd9e4b4ff09b0826fdf5bfd27623b4e84e692021abea05882b029b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4e8a3bddd7f25a3d12c8704ee99b4a99252dd8d63b1c504692f4fc13172656c"
    sha256 cellar: :any_skip_relocation, ventura:        "5f543634f6d0764ccdad59a085429403768525900ca8a010843aa0694b9c4533"
    sha256 cellar: :any_skip_relocation, monterey:       "4955ca23fa4fcf0675f3d879c11bfa69257e48f297f1dd05d9d8d50c7e666d4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5aca177bd950cf56c55f7846cf8d97a39af8ae759eeefeca640c9cb16619ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf2153f633526e36abfa4feb658bd28a3b08bf51220a25c02cb0458ec47f618e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
