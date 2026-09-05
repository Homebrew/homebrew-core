class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "9a53621851423ea758647521be5f2bbc45c97dfca2197e7dfd3a814196a0b783"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a1d28f73dfb85a04bd4d37334cd658e65d5388311e81d2de6283929809e3388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a1d28f73dfb85a04bd4d37334cd658e65d5388311e81d2de6283929809e3388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a1d28f73dfb85a04bd4d37334cd658e65d5388311e81d2de6283929809e3388"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f9c41d8ae8ff72455eaa933278fc9a1180894eb34218ebf1575b58828aca8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a3f10415c9211b25420a08a37ae6e18c3f2a006f03c2913efcaa96a98c437d1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
