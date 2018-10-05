class Helmsman < Formula
  desc "A Helm Charts as Code tool."
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman/releases/download/v1.6.2/helmsman_1.6.2_darwin_amd64.tar.gz"
  sha256 "a6966b1fbeb8f7d2f050e99703a02c0f1435a09fa6b438cbc9bd1b47ed8ba726"

  bottle :unneeded

  depends_on "kubernetes-cli" => :recommended
  depends_on "kubernetes-helm" => :recommended

  def install
    bin.install "helmsman"
    puts "Happy Helming!"
  end

  test do
    assert_match "kubectl", shell_output("#{bin}/helmsman -verbose 2>&1")
    assert_match "Helm:", shell_output("#{bin}/helmsman -verbose 2>&1")
  end
end
