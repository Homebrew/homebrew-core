class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.15.tar.gz"
  sha256 "0c5a5d0f2a7f4a6787de0e601d6ac7e2a84cfce36851ff9c6e970428fa77f1fa"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "05b43d58d6e7e156417534b573a765108daf33dfc2670afbc9e1e3d97abd4a97" => :catalina
    sha256 "90571c23e8167648c7b35dfc0a5af6db81b715a0890d9a77d2b78d8fe5400f7b" => :mojave
    sha256 "728bb6354c3c43bff8de2fcc5d297a959cbcb25214ad5fba0bdf746918176efc" => :high_sierra
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
