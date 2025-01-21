class DockerMachineParallels < Formula
  desc "Parallels Driver for Docker Machine"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels.git",
      tag:      "v2.0.1",
      revision: "a1c3d495487413bdd24a562c0edee1af1cfc2f0f"
  license "MIT"
  head "https://github.com/Parallels/docker-machine-parallels.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6ce0f85c64a896c155ffdd93fe2b55d085384af3b04779c03a4b672b8f2339c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cee48786886656ce8e484a4e04b9bcbf91bf0b1ce1f36688d8a3c7407263f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa5a4b3ed1af696dddb33878a013f92e5b3e72635231f0a3a59eacf483c67c2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07f4935abdf9bd29eac8ad226a63410530ad37324f23d1865cb78585a9d077b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "184912b76e50116c3144467e4da6e35fb8b68b217779cdb006aaf1543d94642e"
    sha256 cellar: :any_skip_relocation, sonoma:         "439730ce2266722643f9ab8acad673e7b3a868b1c506d04b4a0328a1c1b2923b"
    sha256 cellar: :any_skip_relocation, ventura:        "755f1a2c1f2491e122cff8f7d23ba3092a218bd7890e64334eb27a85d18fc446"
    sha256 cellar: :any_skip_relocation, monterey:       "9481f67357cfe0d5b608d32c7570a4d3ba418984d09adbfe6676d51abaadbb5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "29b70e96c49252d2d127098796fa366aec2d66347450144af0b50afd413f8ef8"
  end

  # https://github.com/Parallels/docker-machine-parallels/issues/111
  disable! date: "2024-09-23", because: :unmaintained

  depends_on "go" => :build
  depends_on "docker-machine"
  depends_on :macos

  # Fix build on Go >= 1.20 by removing obsolete build flag:
  # https://github.com/Parallels/docker-machine-parallels/pull/113
  patch do
    url "https://github.com/Parallels/docker-machine-parallels/commit/154f1906924900c948ea8759c711ba43cd236656.patch?full_index=1"
    sha256 "ea6eb1a1f713f6e30bafbae19995915327c8400901e3350c60e40b50d43dd2a8"
  end

  def install
    system "make", "build"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
