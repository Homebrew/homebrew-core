class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/refs/tags/0.2.4.tar.gz"
  sha256 "80291a48e1637c24ac691b5e56061264b31342d35a560a05a6fcabfb847a46fd"
  license "MIT"

  bottle do
    manifest_sha256 "6d133a195d5ae8d568279f98bd9fa093057c9f8005363e6251e41a756e275d15"
    sha256 cellar: :any_skip_relocation, all: "37089a9067afbb17f49925411efa1abfb9c00773976eeabe881562bb9b249084"
  end

  depends_on "ruby"

  deny_network_access!

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~INI
      [default]
      token = abcd1234
    INI

    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
