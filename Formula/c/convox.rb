class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.22.1.tar.gz"
  sha256 "5e39c07cf02e32b773d6ddaf182d9e2e6837b9b35aea8fdc5b382f64d6d92fff"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f34dbc46d321a758bfc9fabe85fd21613f61ee265313daf644bcbc7e02e6635"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f00fde4330b0da4375945858981d74044c85df7c8f21e8308e0e91ec7438fc9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b0938fe67966a4622aafde4416d20105ee2768c987d108dc831543df6662157"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fef259e59eea6cf376c189e96701d1aad2cb4ef6de28090a09831d84f888084c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1aeeba7a62f834c21329bee17bd5e668f9eee3394d76e15db2471356cf12ad2"
    sha256 cellar: :any_skip_relocation, ventura:       "f83c6836af1001eaf42e582d9f1ecbc1f2c89f1914fedb9675569ecc8f8b8207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6918066528ed565b050490257e92dcbf7764d2e4fd3813c501e5c8d53c94cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92841f11f0cfd2f3076f24ea6ca76268c2c63dee458873f7f594002c6b5a9e1a"
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
