class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.9.0.tar.gz"
  sha256 "b7a20e318b7113728912dc0199e86e7ee9c6aa36114544bdbb8e7a80a7358b47"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6c7b96db3990b4c5a3ceb8e2878db4448dc4e895da3538632704e435f4816de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb031f5c5da010bae4ad0492b98eb9ae034e7956ec8e369f2d8b58b273ac9d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cfab1b2783221e96ba474ace4e507998586cf9a381447529b60525ef82c3cc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "82635bf2587e9c09ad86fc6668332cd923e68b3d51475ea8f5afeb0b76cde0af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00eed1115584a55459bfa1b05b0ff455d7bb4c8718b6da6060b9b2529c8b875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0ded86e03be092098c91dd4519bd57a9bea5d7dfc843889e5dd148c5e75a261"
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
