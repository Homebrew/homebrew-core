class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.9.1.tar.gz"
  sha256 "6d86eff26ed036ac77a136e7f4c2a31cd7f1860af97eed7bd0b2b2202114acd2"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01473c20c21dd9ac4c6c185752ddd3f962f1136c492a1a13381aa52f720d5442"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "347009e429b2ed671e00db139d74e55ae9a1eec251681de52f04e150cb2ffda1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd268117cbf1ac435b047e900129e8470f7a7353f841f21ba97ca161b3f35321"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb02259e8b6f329be57e1399427369b694a898d8fcffb23f048a16d7ead25e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fe766798c12ec8ff64800f654d42e4651a1383b15fd8bd244acf55f4edafa78"
    sha256 cellar: :any,                 x86_64_linux:  "1a8a35f67d7d2c7761c30bd49b416717d3a5cfb95d95972eb5fd3bd378a2922e"
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
