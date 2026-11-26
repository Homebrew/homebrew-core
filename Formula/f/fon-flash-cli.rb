class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://github.com/ericpaulbishop/gargoyle/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "6d1b64d1ce2876b89dd70d4dae992bda76a37664d228459c0525076039aa6a16"
  license "GPL-2.0-or-later"
  head "https://github.com/ericpaulbishop/gargoyle.git", branch: "master"

  bottle do
    manifest_sha256 "bf5af32f0d80f8e899d48945b3ec87a68cd38baf05eb3784e3267acbc55075db"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e30e6f873b0b5418ad06a74fe7f008f9bfedbc6e72f3a612db02029522c7fe47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b5d39fe8115ce5355f39a4f901c9a715e1b0517afd1ffadc7930299bec5da89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "299caba41698f5768bcf0a7a311f79834cee9374885e425e9aca322baa761864"
    sha256 cellar: :any,                 arm64_linux:       "aaa992f0aafc7b27a031927d87a2b5711990291d3157cef7cd2e6eaed64ba092"
    sha256 cellar: :any,                 x86_64_linux:      "f0aefc0cada2601c90e7bc530c3061e7c8f36a9199064b554d6f1ab45f42102f"
  end

  uses_from_macos "libpcap"

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
    end
  end

  test do
    system bin/"fon-flash"
  end
end
