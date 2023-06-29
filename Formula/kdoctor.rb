class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "7d19d3ee1d15ec15fd953a412f8e699b0d2d91f83eb87b36a8603709d64866b4"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1fd2173136a43a08d794e4eb94ad7e1f8aa271436d4c1e199aae47b7290f26c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93adcaab04918588fef66fd5bd0bbadf9752dcefea386017430b49143eb0bf4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00a9a58e91adbf50dbd69e9f039e392ed8471646d951ef94bfd5561c0ab72e31"
    sha256 cellar: :any_skip_relocation, ventura:        "88b80453404bea546b8ad6e6881d2d2e9eddc646f10e91de9ba92549c1461a09"
    sha256 cellar: :any_skip_relocation, monterey:       "d17a193320cae7962d1b53e3892be3103e0ccab32107f808139fad117a0c376e"
    sha256 cellar: :any_skip_relocation, big_sur:        "185d2f5b00e61693a7f7328a9f22eac9e90ea8ace31730183aeefd476a490112"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "kdoctor/build/bin/macos#{mac_suffix}/releaseExecutable/kdoctor.kexe" => "kdoctor"
  end

  test do
    output = shell_output(bin/"kdoctor")
    assert_match "System", output
    assert_match "Java", output
    assert_match "Android Studio", output
    assert_match "Xcode", output
    assert_match "Cocoapods", output
  end
end
