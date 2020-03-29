class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.4.tar.gz"
  sha256 "cc45eb5de17a1957124545e11ae6dcc6e3957e9d5e9b06acf37a341113963829"

  bottle do
    cellar :any_skip_relocation
    sha256 "45be2821fcaa9e3d978d041b91ae6157306ee73f6924b0cb0c7ad7e4eb2b3254" => :catalina
    sha256 "bdffe99b9524f0bf10cb23e6a25c3a8eafab8ede6f8303bcb100a8097db9ba23" => :mojave
    sha256 "6a79ee6fc88b5a450348d977b8adf0d14c80aa5ba0bbd22375d1795cf3d8e070" => :high_sierra
    sha256 "3b6a51b5a9c9ee58510fd70416dc8953f037e3575a255b6171363d2364bce1be" => :sierra
    sha256 "e0ec971459deb768c19460db26246dcd2ea71baa34706052d0a4f572bff9606d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
           "-s -w -X github.com/prest/helpers.PrestVersionNumber=#{version}",
           "-trimpath",
           "-o", bin/"prest"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prest version")
  end
end
