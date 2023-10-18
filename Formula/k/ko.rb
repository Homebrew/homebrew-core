class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/v0.15.0.tar.gz"
  sha256 "7d1f54b07f95bfa3fe8b1d3ff65e824208156c8c6952762bfbc2d2fe68573831"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35d367205083dfd07d474938a7aab7ab1b7b31cdb4710a1929871be86d36a19c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c36bbc734c4d8a33b3eb9e32dd20af4de83bb7751dfa963771b20f80a9b3a35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "000e5f0ed16533ce076e60467dfb2294d036bf32a34c5ffa38ad87cb2ed25372"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb8e997f04f61e4a08bc89379b132984f453fb19206d0074ed612df42af66006"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e843aa0cd5e971bc05b86dcd1cfb45d8f9c2856f2bdbb1db744b4b7ad8771a"
    sha256 cellar: :any_skip_relocation, monterey:       "4514804b91fca268be4ece6480c3863ef4f3db68a9ca8b969dfbc994d1d68db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03ec1550d68a58008215a87eab5e9bdffec3228e242543e3889d1d6e1470f8de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
