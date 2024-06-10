class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.18.5.tar.gz"
  sha256 "efaa45002c5447badad324a15f06790eda0e1aebe312b6529d0ae6791b46213a"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9cecd0edc4f48f368b545d7a815c04da7e85231c4a548f72ee687ff04e25405"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d17fb6606d7bb0099316446acc10699fa4e6bf480b65028eae612ec46109471a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea02eb53f1637988cb0403f0758c7eeb5669196474b5b0ab3ac90e5ea0824edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fbc61aa606780f3c4adac130b58b4988f5775709d763c025a7eac6fa1d6d61b"
    sha256 cellar: :any_skip_relocation, ventura:        "0ed04b6319fc9f60ab540c44266b627ebdac671835697c85c67bfbb8e5f0a633"
    sha256 cellar: :any_skip_relocation, monterey:       "f543fc49f38cd1e20d9c17fced73ce399a9c5de20e26e9969f4c5a323231cc36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c56a0dafe64eb4562e9e3c2a90d578785832952f4302d73dfdc99ab700a7870c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
