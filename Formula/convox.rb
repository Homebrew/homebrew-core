class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.26.tar.gz"
  sha256 "bbd7f17830525bac4e91d4ffde1734c2acc51f1b25716b291ea0d02e0a976c81"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b021588e01734b7134a56195332200300326bc2b9950e52aaa7e2fc2c70863ad" => :catalina
    sha256 "3ffb6db74c425c71a02c914fdb6022a968605125c237a7cf5c2170f587c5201f" => :mojave
    sha256 "bb3fe1a623cc8ad3f4771577b547cd9282a42fb369f089632da7fba08fd419ec" => :high_sierra
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
