class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.4.4.tar.gz"
  sha256 "2786ab0af06aeb8357ae835340b96f30ad1b134280faa346f0f250df5c7567b1"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd11795109c0ee09d0ab81c1a35861215b8a7afedb6fa7d4148535ffb23a8b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a35ffdc4052f39ff43b89c2cac5b55385d46ecf0501b014ba5cad3b3f96b4249"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad74bdcdc3786d799e8394748683aa78137f97a7ed98c10cc6d287cf9be2fe5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8754892375d921d9700607d68d85ac0a430f0e98759a787b76bc20586490faf5"
    sha256 cellar: :any_skip_relocation, catalina:       "58836775c2ee4ac9a78747499daf4582cbb193461a280cd798beb0dcba7e7291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80998cf1355ffaf5939ae34b17b747c999132b18b5efeffee2dc945b72cdd41"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "vulkan-headers" => :build
    depends_on "libxcursor"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/caire"
  end

  test do
    pid = fork do
      system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
            "-width=1", "-height=1", "-perc=1"
      assert_predicate testpath/"test_out.png", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}/caire -help 2>&1")
  ensure
    Process.kill("HUP", pid)
  end
end
