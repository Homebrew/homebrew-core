class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.20.tar.gz"
  sha256 "335ebed03c821955f1e12b8b4cf38243395991f1f3c5bdec8dd9c861beff5496"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "dbdcaaa7bc56644f8f4be35d22126f7e94ef882de5134ed9608570729d673d22" => :catalina
    sha256 "8e281371df6dcb3c3a593494be2cba1c9bf3435f0ba001fd4496d5d4b074bf6b" => :mojave
    sha256 "29b79c748512186b84e664193a2e5aa20c6cdc61a2aa67117216a6980885219c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags=-X main.version=#{version}",
            "-o", bin/"convox", "-v", "./cmd/convox"
    prefix.install_metafiles
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
