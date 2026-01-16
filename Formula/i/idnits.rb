class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://github.com/ietf-tools/idnits"
  url "https://github.com/ietf-tools/idnits/archive/refs/tags/2.17.1.tar.gz"
  sha256 "195ed8c9bfd38fbaf1ecb674a894f98f43be774dfecc37da5ef953ccba99ce76"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0821ceb278c9bb73ef75f4aa1ebeca58d6e5264d4360d63ccdf0d1b43e23d2e6"
  end

  def install
    bin.install "idnits"
  end

  test do
    resource "homebrew-test" do
      url "https://tools.ietf.org/id/draft-tian-frr-alt-shortest-path-01.txt"
      sha256 "dd20ac54e5e864cfd426c7fbbbd7a1c200eeff5b7b4538ba3a929d9895f01b76"
    end

    testpath.install resource("homebrew-test")
    system bin/"idnits", "draft-tian-frr-alt-shortest-path-01.txt"

    assert_match "idnits\t#{version}", shell_output("#{bin}/idnits --version")
  end
end
