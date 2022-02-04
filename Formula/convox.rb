class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.3.2.tar.gz"
  sha256 "3466f069686ce15d4b82cb533521b64a8db2f9dd1f155f72b14010e8e159e656"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0feee58938a30346a803f0dde484d992cd0bd9aa8206f186c207ed1db59c7de0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae46562b30e17c780f0948139791e5d6b7790c190fa43611c2f808f95ee09b34"
    sha256 cellar: :any_skip_relocation, monterey:       "37b137990c069ed622b0523a3a90dba8f13c70c7eec2ba6598c63e9dfaef6848"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9209d19eaab5474e2692572ef5c2a3c2cf67ea03b4eb57b7963d84f542b94ad"
    sha256 cellar: :any_skip_relocation, catalina:       "5b15c2ccf714fce71020d458ec8b4a08dcbbb3705c2eb651493d0b479507277a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cbe216cdeb15f492dcbeac2ce9013b4be304882f6e4b5f9f1e52909bc4e9b44"
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
