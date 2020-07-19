class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.32.tar.gz"
  sha256 "2bbe589cdf0ea4e56992d330a75453ab12e219888b45b35c1318aad4d53ab6fb"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3f83a13ef234ec28f484464aeade3f9ca514dc2fae0dab83f9963dd5c98f7221" => :catalina
    sha256 "9bf1b6e64b2866c964a32db058b9c3bd53e305bb005f7c96cec4f969449f7ed8" => :mojave
    sha256 "51861918f11c3a7f4312aea64f299ed50f2c726a5708c6c26ece14b8b66fc704" => :high_sierra
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
