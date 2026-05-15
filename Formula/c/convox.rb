class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.24.5.tar.gz"
  sha256 "5824204fe7e47dc680726e454fb5d2a8cda2b504dc4824055cb276661c433386"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "487f7af250d1234306cfef41520fb7b281d68cac7c70b16795de0b1134d85dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8de79ca2ad004186d281789d6f77e394186eefff362906502e2e2f27e0afa2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14adc9009f1df3753417b970ab2ee435a55b64fd03ac9a89245aad2f4f537876"
    sha256 cellar: :any_skip_relocation, sonoma:        "13fea59a678282d44316c5f8a21332fb0a1bcdab0cb1da370c49edb8a8d4d2ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8b3606a78cb1af920b06f962883eb16fa890aae5ea3e91681a2118ba627ed95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aeae7274ff5ceee44b6aaf8a6f0ffd02f4e472cdfa6eeaf13a897cd9109964f"
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
