class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.5.0.tar.gz"
  sha256 "633a0a599a230a93b7c4eeacdf79a91a2bb672058ef3d5aacce5121167df8d28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4e13f2e58d6e125a578aca41e192b4e655d8daf706e8c1fc154b77c4d884984"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "688199921a304a5ba1c0ac78096d29c86c63076eafd6288085664a32b7e70056"
    sha256 cellar: :any_skip_relocation, monterey:       "8049a6d438b7a088de9e71cc0356feb1f7576d678b6aa69932b97fdd84c00596"
    sha256 cellar: :any_skip_relocation, big_sur:        "e71157c4ff045c0e9330fc916b473b38983af56bef7aefd3cdbfd833d9467c18"
    sha256 cellar: :any_skip_relocation, catalina:       "5589478caf3652ea9a8ba5dd95ead4a927f5a2d4436abb394113e027b0fea805"
    sha256 cellar: :any_skip_relocation, mojave:         "a247529d915f53e3d43ea23b017373a905b11a51e8f2f18dc19a8eb90c5e9f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fdb550ff66a46af75552afcc69dd71a93e08097a6e7f94b4e7bc382584c9b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"devdash", "-h"
  end
end
