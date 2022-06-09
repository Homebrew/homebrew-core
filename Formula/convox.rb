class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.5.1.tar.gz"
  sha256 "4220ad93e5e5028c080f140dd353dda9fe74975a39e4a6c1218eabfd11156c42"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98440e6200545507ab3d4cee35075495dff6b915abaed3da4470f795f1179da8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4bb76b4c8ce3d2acd3167fb7df06c447d0fd0dcd547dbda26d20ae1dc92a404"
    sha256 cellar: :any_skip_relocation, monterey:       "bd1b840fc6836923c0b401486da91f0212095eb4e62b86bf65b9b6ddd13f6147"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7b4762af923add4583acb93ec69b639f3d132ca2ae067f456b9d3f7572bc140"
    sha256 cellar: :any_skip_relocation, catalina:       "4821bb829c9e7f275f9553d83da4742ff4a6ce29fedd71b268b9e55a162ed169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad33224a2575d9de5ec593cc237c07eeb031a14ec258eda38f49713558b355c"
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
