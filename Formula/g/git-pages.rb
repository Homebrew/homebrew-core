class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/archive/v0.8.1.tar.gz"
  sha256 "90396e265c5336f76c2ddbdc3c67b73e3d500e83283175efd34a9df989a6d94c"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b13aa0d47bc89a17d55f4df50ee22cd1d61839e03b15d0448ac07f4c0232a60c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b245c1860ae4f757f3b04808ea88f341330437901a3866b455fa4decb8a8b0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "840b63f65c5f1e158d05d5fd0565a67c35a11d9fd2a5af80ab00f61498991e6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "27cc4d876946716255451735b01b4b290a858b8427dc3eb7d35337a974fa54a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23aa76e6e3ff755988e0e005dfe9877b3829abd6525108aaa2ef42394d402395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02e46e5d1eff2e97020179784dc2fb5b38f5d8cbb2677b0c83a660078483bad"
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
