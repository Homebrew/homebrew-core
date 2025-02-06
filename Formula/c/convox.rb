class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.19.7.tar.gz"
  sha256 "1d30881ad7d08114abe6bca1109a9db944db6245a76ff55138fdc01378931e68"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a8732a890cab557519fc16525424185097329aba946df2e7426ea576e5545b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e32080d07be5ac2034f5561a9021019bb34f9e9435ab5534bff87a07c445d580"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "efd8bfeebeb09cda933eb542bf48d5b406be38d1d7c31b00df53c2a1e5ae8a39"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e92e28c3bf3b2cfc0e360b4f335a42d6e01141ef3d266e9a167543ca3e8ad7d"
    sha256 cellar: :any_skip_relocation, ventura:       "9e50c098f471f1c581f0c466f74ed11be0eafadf3a29cb22a519dd7e82a486c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd292b9576997c276b4dfb6b237da77790655eb7ed3b927d98c927be6e8b1d4"
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
