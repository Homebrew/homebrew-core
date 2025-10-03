class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.13.2/fwup-1.13.2.tar.gz"
  sha256 "7ae6d373c38853ac59a06201c5c7b2cbe1fc601057e4417710838303325f21d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "356da4ea4e347b46581bc70845cd86d4e7265d5811d0d199fcfcd78a1df82b73"
    sha256 cellar: :any,                 arm64_sequoia: "42e1c381f3f10b5f735e06c311c487e12c35eff57dbb50f0a37b2636c8530820"
    sha256 cellar: :any,                 arm64_sonoma:  "47e57ee087ad76ae94fc90f11a7a3f9408096075c0c4a0d75f58f590705914e2"
    sha256 cellar: :any,                 arm64_ventura: "412d633d3c2bf02f0288b081fd4b57b315b00332f6990a3d6c89a54ba85db13d"
    sha256 cellar: :any,                 sonoma:        "ea8a31acc0a200921626e502d1ad49ac47906913986a301cfaafc5b3aa5c4764"
    sha256 cellar: :any,                 ventura:       "5517841dbb8f1494078ab96d88ed61c2c37faa3ea6a7da1ffd64e1e83c1cd1dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cca27211d8e0dc7507396d533762a4408581cc1a283a8c6828ebb87815b2c0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b767468618b5b325b588466aa8b767e49a8d5c6de9a718645f63652dc0c3676"
  end

  depends_on "pkgconf" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_path_exists testpath/"fwup-key.priv", "Failed to create fwup-key.priv!"
    assert_path_exists testpath/"fwup-key.pub", "Failed to create fwup-key.pub!"
  end
end
