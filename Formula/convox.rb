class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.29.tar.gz"
  sha256 "31c74af451d68c14a0a927f96afb81dbe937d4971e3974484578109dc14a9f81"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6db4cb92ddf1e602ae01171f9d7d289d8697ececd5ecbfeca0d25384bbbcd418" => :catalina
    sha256 "8ec2a8fc080212c2037bef572f65347e753e3dad0049daa44b47a494cbf339f9" => :mojave
    sha256 "51d980146bb1c47f67ff93aeff244a669b8b3b426450a51d18e60ce480aadfd9" => :high_sierra
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
