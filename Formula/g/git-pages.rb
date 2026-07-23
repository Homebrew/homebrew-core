class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.9.1.tar.gz"
  sha256 "1976bad8d2d1f24034c554430ae34716e42c0dc25d777c1378cc953fe4b4d9f8"
  license "0BSD"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35819b00812281a3f8d64323dfc6b9666763f9aa2691a2bdc3a7e2dab18ddb0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5adce1a7a7531d52f45e5d197d973ecfc25445ed3cc337c4679cf7b4cd354fe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f871ac2d5ef36b388c60c6247cd4d50f8a296878ed29b6c7cadd464b95e2f199"
    sha256 cellar: :any_skip_relocation, sonoma:        "b49a4b58ea651cbf70a6cea8a7b4eb58267ee1fd9352709e1c3016d9ee8875c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d893294c68c24c584cf78c328c73e70e17e4c83a914fedb4dcd3d118542ddc5c"
    sha256 cellar: :any,                 x86_64_linux:  "c3d2eb18b5c093cdfbedfce8865958b7146e3b9b9a983952bd7aa1ab148e2372"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    mkdir_p "data"
    port = free_port

    (testpath/"config.toml").write <<~TOML
      [server]
      pages = "tcp/localhost:#{port}"
    TOML

    ENV["PAGES_INSECURE"] = "1"

    spawn bin/"git-pages"

    sleep 2
    system "curl", "http://127.0.0.1:#{port}", "-X", "PUT", "-d", "https://codeberg.org/git-pages/git-pages.git"

    sleep 2
    assert_equal "It works!\n", shell_output("curl http://127.0.0.1:#{port}")
  end
end
