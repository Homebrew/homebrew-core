class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.6.tar.gz"
  sha256 "93d20b021b47434766607e7f9332671798cbf8f64382ba7a8375fd9deb3d4cda"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e39012dcf45e190cda3e000e2fc00624840f84aef874b35bdd82def015cf7d1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c786eb3fac3c0346460af55f6908aa0fbb46ba6e6d4cc98f246d4e48c4cf4ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ecdab9126fcca940a3ab5f88e227ae9660a12abe3b4a185407ea9697e08bc67"
    sha256 cellar: :any_skip_relocation, ventura:        "25efa7ac6005d750b93f42bc2abaaec8567575b6f99631505a5b85ce842d8e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "8952fdfbbd0de05435e52390047b5adedfa807e0f8f9f6d5cd1b33c97db393e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "57888c9ca2a7c3bb0eace4f10ef97e1606cc983fa6d859885bc860bec1a3c254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0e2549737b5fb6dab8866f3534b5d37a6e4451acc12958b6391e3b36463c19"
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
