class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.11.3.tar.gz"
  sha256 "2d34103a7f9645059270763a0cfe82085f6d9fe61b2a85aca558689df0e7b006"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "179e07bb22e2755e3d082f07607cf2e98e266defaace3ceb764a4c32f03ccf8d" => :sierra
    sha256 "5be8ef01a8568b7de75b19d525a4830b0c934c43b9e8f9fb150cbdcb18091a26" => :el_capitan
    sha256 "6dcf9d7de2489f5e3d6fd56488c3abe2bff1ea6f6bf0d9de89421b0e9a7e2e38" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
