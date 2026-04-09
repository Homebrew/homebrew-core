class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.24.2.tar.gz"
  sha256 "7254d4390ac04afedc04cbcd3cc41169479f99cfa58cd9c6cdaf51d6e12963bb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ec6402eb663c28201829c06ecc95e46d1c19ecbfb6e2f4d2ae121f53fcc64d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64cbffd6181b8ad2bfb727ba64ef17cd4adbf9e72a1b81833da7bad742e572af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4770ad9eecec98caaccac7851a4d29859cd102265c0a96764ffd451dab73811"
    sha256 cellar: :any_skip_relocation, sonoma:        "9302deda44ac830c342a00154f6c2f6971c4c39a525e472a521c78a89890ad67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24066d5b83d9cb29cc92635936b5b08ce41bd753e44cf438615c5d7e7a345ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd422d42bdba1214c0fc74332038ea4e5e8622e99b68f535d601d634b89649c"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
