class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.7.0.tar.gz"
  sha256 "3032ffc7ac826ec1fbe9df42fd5f2c5dbb5571eb30db2d3543a75397ac2d7b37"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f9d4756cfab7dd071aac46ec9c3ef73bbdbca5a4cb2dfcf9870e26275ad552"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "575444ca0840cf1a5d34757b99a222c8ef9019c33757797157cff923b415083c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a382d5772cb504358dc050b21c3facad42dc980b49e09bf2ee798e0fc0719929"
    sha256 cellar: :any_skip_relocation, sonoma:        "2131c15f08b83d655884d0a49ef302fbef39bc20da1989bcf9eec5873ee40688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1c1b680b3b084d3bc65ee67429476bdabd1cec11ab73042ab4472ea00b1bae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a26c50758c96517093f313bad74ed6dcd0e719589214ed717d371a0d65e5d1"
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
