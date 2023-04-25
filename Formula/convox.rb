class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.11.2.tar.gz"
  sha256 "367f8cd4caca8397dda2be2bfc02cf971f256f0080c806b5098a635d951c3aa1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc34b1937436a67a939888e3b55b3e5fa1dff9ef521d0b0e1219a098cf8146dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52f86366b2cfc092868530a16a78885d17af596125321ab1a73ccda4a83feab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "954110c3d428dbae3899acf0bf1896344fcdb92042586bd77062aaf4ba5ac8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "8c8a16a0c68b1c71cbc59f9efbd61c3f99c50fb9ae22d698d7b720ba74d82540"
    sha256 cellar: :any_skip_relocation, monterey:       "38a2b71e413ec98c3a2a9fe354c26d7aca004f95c801d52a37b9702481f9efd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "931309daf846b5bbc9c92aa95f93b8ec39810c5db8d269bbcbee1ffc22bd55a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a321832ea3e6ed054d21b1555e6c6fe86cadba6d107babf9c3162e923f1a06f7"
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
