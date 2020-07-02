class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.26.tar.gz"
  sha256 "bbd7f17830525bac4e91d4ffde1734c2acc51f1b25716b291ea0d02e0a976c81"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b059a013ae71e82ad47072fb1ad52c148fe3c06c222ad16436820e85b0f73022" => :catalina
    sha256 "ebd896aca14faf93bd386cac4ecc50b41914a3aedfa86d10c3e0d430241ee627" => :mojave
    sha256 "de50e42271669f8f491fb4855ef2bca4bb51a4d68645554b79d01999296689a7" => :high_sierra
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
