class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/refs/tags/3.7.0.tar.gz"
  sha256 "f970a4dd242e6b58edf51320aa237bb20d689bbc8fd0f7d0db5aa1980a2dc269"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c61bfcfc68cbce95932c5defef0f61f180acddb95a64b9c205dae59cb0e5a2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc237b7b1e28e0974312a7b154dd06b8bc5cdde57f7dd197e008b7e1450d9ffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e93a4812623537c4f636b81238d48049c2aa74920c4b34945d317b0001714e11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00bbb0435c2d8478f994220e4b209561428a535bb36b9b298f169e51f8abfe9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd6f284fbde2693d59cafed00f83c1d8f997578f05b46856d757efb5beb28bbc"
    sha256 cellar: :any_skip_relocation, ventura:        "d0a210912a499f329ee9709b5544147df22ccb09544c323f1ecdde4dcbbfe956"
    sha256 cellar: :any_skip_relocation, monterey:       "468ea5232ab7fb8acd9818fe0c285a38f2b16eb23bb66b1d57dedc5c572f443a"
    sha256 cellar: :any_skip_relocation, big_sur:        "32a52ff508147b1ff62967f173391b14c7f865dc1a56163b243e71c3d38f2bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01035f395f9d150621351e73a6f87091dd10d2af579ffc1c1b636990f6d937e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/variadico/noti/internal/command.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "cmd/noti/main.go"
    man1.install "docs/man/dist/noti.1"
    man5.install "docs/man/dist/noti.yaml.5"
  end

  test do
    assert_match "noti version #{version}", shell_output("#{bin}/noti --version").chomp
    system bin/"noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
