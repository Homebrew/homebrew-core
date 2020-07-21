class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.34.tar.gz"
  sha256 "5925f568d0721d622d4e02fc27268358b654222c43acc0f7cf46cb8df12637da"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7fdff1247bd3c2ba86fe617232d0ba2fa185d8830f3a3a77055466aa1dd9b64a" => :catalina
    sha256 "035eb53a9487add8bfd323a19644d999c9b190a5e1477461136627a22e7b04b7" => :mojave
    sha256 "81d9558502513a868efab1c25edb7202846b04d9181b7f2f5079e57b56ecbe0c" => :high_sierra
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
