class ManifestTool < Formula
  desc "Command-line tool to create and query container image manifest list/indexes"
  homepage "https://github.com/estesp/manifest-tool/"
  url "https://github.com/estesp/manifest-tool/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "97a9535830d6cd9d382c1d9ebae01a64dcbb400c540086a738e0e5297904ae3b"
  license "Apache-2.0"
  head "https://github.com/estesp/manifest-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff6ca925edd27743d5951fa56f113293fedc984e85a981acb47469e831ecd8be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8397acb5e94f556bd7bd1912f490cd78179c68a34d0aeb19a436191463f3686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa96b91d56f4bfd7134538576efbd412a71272bceeb7485225a59b06de33d1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "301afe0b73ddd03fd4bcef72f57e7511133a0068252b8accafd77f8381b7cb55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9820c2efb7987a017570f456dc8fa1050f8b70bfb3fe1494d4f8baa9910e5fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6975815c6a6ca38ef57adff084060f96b886d66fa7be87b50c3ab655943cb2"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    package = "busybox:latest"
    stdout, stderr, = Open3.capture3(
      bin/"manifest-tool", "inspect",
      package
    )

    if stderr.lines.grep(/429 Too Many Requests/).first
      print "Can't test against docker hub\n"
      print stderr.lines.join("\n")
    else
      assert_match package, stdout.lines.grep(/^Name:/).first
      assert_match "sha", stdout.lines.grep(/Digest:/).first
      assert_match "Platform:", stdout.lines.grep(/Platform:/).first
      assert_match "OS:", stdout.lines.grep(/OS:\s*linux/).first
      assert_match "Arch:", stdout.lines.grep(/Arch:\s*amd64/).first
    end

    assert_match version.to_s, shell_output("#{bin}/manifest-tool --version")
  end
end
