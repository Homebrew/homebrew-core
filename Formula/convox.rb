class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.3.4.tar.gz"
  sha256 "4d537b6a3837723af8545adb71c10abf68c556538ba993babaa4670bd8d684d0"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc8e90e46003d115f1432c7506c79835cd79792484d818503870f16ce5c9267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0131c83d4fac13f46c11c433365adf423afd76f5baa96bb3c173cb16c29de8c9"
    sha256 cellar: :any_skip_relocation, monterey:       "de1e2fb8fe0b8eceb50fd64c071428014c4850f32838fbbf424886860c70810f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e3532d53a8f95123830af1c68b968fc5398ec0a82db7c06545da15b925018e0"
    sha256 cellar: :any_skip_relocation, catalina:       "8d0f9565e1b68fbcc0475d802fa52a0a7fcd19130e1900e54b3ffb06f2ce5cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8acb1c6c8f687e5a698ec284e1436d868576dc966098d8e419ed53bdfbc265ae"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

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
