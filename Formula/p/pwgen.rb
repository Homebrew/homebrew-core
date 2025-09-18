class Pwgen < Formula
  desc "Password generator"
  homepage "https://pwgen.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.08/pwgen-2.08.tar.gz"
  sha256 "dab03dd30ad5a58e578c5581241a6e87e184a18eb2c3b2e0fffa8a9cf105c97b"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7b3297c6e36caa295415af3c677a5ef056f824ae8280d7eb5023a693848a0dd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78e78f3269e5a571f309e859d1765104c3a85a227bc12292efe437ca838696bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8d6d5e6fb87ca3906b04af23e27464f3ae52100e9f0c98ed3cbbc9701e47a1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae06c8a28b9126b1eb4ce8e02d88b761d76ed35499de2c71881b51b247e9d612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c66f05513440592d1642a258992d076ff1b3c86f3646c88861aa0f4e443f6b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc4d1e845384c5170c9fd6e9c5b054e152b8690763a55b3c9a1a0e51fbee31c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8abc21c960ad147e32253c1820d5119c1b7675314ee9bb89d1b4e91a6009740c"
    sha256 cellar: :any_skip_relocation, ventura:        "8c83635eedb3e60f976b8b36c618cd29b8e08fabd8cda8cfecad02d04b74169c"
    sha256 cellar: :any_skip_relocation, monterey:       "d83b242a43d7403f540e56a85399132205a38f5972e8eb2b8744e709b1da2bf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a47de6eec09b1a2e938da0bebca8386261bb63040f9ca77fadfc3d28db7efc8"
    sha256 cellar: :any_skip_relocation, catalina:       "725911d1fd71b259acb7b907c09ef86a03545afe95e161856130992fc0789ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6115d9586e530f771801c25cde3ba6c33b287db18d84b73911d68721b5cd7eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d869f0f3b08bf09648754a037fedc9a729b1b5e718bc366e2cf9a7cca2861813"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"pwgen", "--secure", "20", "10"
  end
end
