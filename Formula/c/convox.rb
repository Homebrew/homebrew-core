class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.17.0.tar.gz"
  sha256 "592a311ff93b3891ae29063f911d356b4bbfe2e93ef39a7123865cd6087dcb12"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "389a9916241dcb4899b9f67363e38075ff4b70c02a3cec4c5f836b43da1499dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c8b8ba2c463c6989dcdb6903965a54cd1a2d73c1605197a2db38d9853fa3148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f3150412f1337fbc931ee8d9a95825a439711e5f761959e64b912eb682fc914"
    sha256 cellar: :any_skip_relocation, sonoma:         "716184c502d4317c2a5919ddadb2930a087ccfdc62e568d76742e995140caa51"
    sha256 cellar: :any_skip_relocation, ventura:        "d0a95ab8cd32b3b9e6af57cedc75d8f753b6faebd0fba793af93c8a2f87260ea"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8c770dd666c35073e4e672515cd8fa2ea65aa973b3f8bcdaa58772158572d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "223e477bbab0fc4f037b36664dbb6c0a81e51de5cc1e04d9df7468d6a3dcfca6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
