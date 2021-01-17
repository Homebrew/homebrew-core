class Flawfinder < Formula
  include Language::Python::Shebang

  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.15.tar.gz"
  sha256 "0a65cf93b1d380669476e576abbb04ea0766a557ce2bf75d9e71f387fcd74406"
  license "GPL-2.0-or-later"
  head "https://github.com/david-a-wheeler/flawfinder.git"

  livecheck do
    url :homepage
    regex(/href=.*?flawfinder[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cc2b451e91cddac64a29f13a1814bd5b481dcce2ea86fb5c5652b4c90cb7f63d" => :big_sur
    sha256 "8f5389db1dd74bbe6a91c856ef66e49de443a08eb6d5864dda113b2593a347bd" => :arm64_big_sur
    sha256 "76104b50b01df54c7eab1c58a4bda74ae890e935caa151aefa5ea37bf8ea87f3" => :catalina
    sha256 "f7fba945f5bc32530cd73e9d00627b47e129ad6e2562a748b54eacba6a40404f" => :mojave
  end

  depends_on "python@3.9"

  resource "flaws" do
    url "https://dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    rewrite_shebang detected_python_shebang, "flawfinder"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
