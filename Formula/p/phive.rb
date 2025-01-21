class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.15.3/phive-0.15.3.phar"
  sha256 "3f4ab8130e83bb62c2a51359e7004df95b60ad07bbd319f4b39d35a48a051e27"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8541c0554a7138cf6587885fc6ed16995a1f70f5dd5aac19efce72ea42fb8661"
  end

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
