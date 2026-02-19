class Fastjar < Formula
  desc "Implementation of Sun's jar tool"
  homepage "https://savannah.nongnu.org/projects/fastjar"
  url "https://download.savannah.nongnu.org/releases/fastjar/fastjar-0.98.tar.gz"
  sha256 "f156abc5de8658f22ee8f08d7a72c88f9409ebd8c7933e9466b0842afeb2f145"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/fastjar/"
    regex(/href=.*?fastjar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cb7800d86e7f8733755399304f9ccc3ea3d44c7d7ca6fd81b2f6aeaf5cc6061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "329d6b5ec4a5bf54fff26334797bac30f2205512ae96f20b873e2f1722936272"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64d57548564e62bfb5596526292bcd91bfcfa98d738a3cc2dfa6ffb15ef6e7f1"
    sha256 cellar: :any_skip_relocation, tahoe:         "cb7cb95278b7bd92763f885c4ee77dfe5f67e4fa9615ce39fa25e34aaf630b17"
    sha256 cellar: :any_skip_relocation, sequoia:       "178e8785a42f84bdc16ad580b5fb18002766a7a335f848f7606dfe4ad71d5875"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e990e3753d3b28c8921e6b9005389da42ee4967ae7ba85f266364068208847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "640961ee6c8698dd49deb1426d811811f9a65aa31e7baa565780c2b51914cbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf0d96826dfa9aa1ed077add9271eb0be8da1d8af8b0a31344d8fb9bce550ba"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fastjar", "-V"
    system bin/"grepjar", "-V"
  end
end
