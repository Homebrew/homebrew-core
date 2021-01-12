class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v2.3.0.tar.gz"
  sha256 "bd5e08dfbbb2ed4c1ba6c960365f34d916e913030e94d3f0515fedafa9a2c8bf"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e394192ec479375b483f5a882e01f1ade6b03fa298e7d52b85c3013a27e0282" => :big_sur
    sha256 "05a6430db194b98832d8c63383176e1f7fd77a4633feabd71703e9fa48090830" => :arm64_big_sur
    sha256 "203d2846cfdc7f20db09dde616c72cbae7fcea10b55076aa5c4c0fdf499c01eb" => :catalina
    sha256 "ac292f74b86e7d96493e34a2c003e14aab9a3a913e099a8ca5ee295c866de75a" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.AppVersion=v#{version}"
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "5 B file1", shell_output("#{bin}/gdu -non-interactive -no-progress #{testpath}/test_dir 2>&1")
  end
end
