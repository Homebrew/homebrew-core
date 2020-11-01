class Liquidctl < Formula
  include Language::Python::Virtualenv

  desc "Cross-platform tool and drivers for liquid coolers and other devices"
  homepage "https://github.com/jonasmalacofilho/liquidctl"
  url "https://files.pythonhosted.org/packages/48/7e/fd5faf6a0174c1e19d373bac108de164acf930d7ea7277359759ddcdc5a4/liquidctl-1.4.2.tar.gz"
  sha256 "39da5f5bcae1cbd91e42e78fdb19f4f03b6c1a585addc0b268e0c468e76f1a3c"
  license "GPL-3.0-or-later"
  head "https://github.com/jonasmalacofilho/liquidctl.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0576c2c42d71f540b597bd82123089e672823b78fad935a66be454199720a4cf" => :catalina
    sha256 "cb19ea7668ed3cdb0786b349fd070934e6ca1ecbaf7802d6dc0926fd33f6fb4d" => :mojave
    sha256 "05915ab1acfcc7b9a4c39db5e45e964f109f7b2349e95e58d38bfafa9c3528a3" => :high_sierra
  end

  depends_on "libusb"
  depends_on "python@3.9"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/52/4b/0d0fac70bd0a04949113a9ca50ba7b2344f547b9d85b0e7e5eded19d7d50/hidapi-0.10.0.post1.tar.gz"
    sha256 "27c04d42a7187becf7a8309d4846aa4f235ac8b7dafd758335b109f5cbd3b962"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/12/9b/8f5be839753667c39fe522162bea7f8121f28ba49c5ad1e5681681967c79/pyusb-1.1.0.tar.gz"
    sha256 "d69ed64bff0e2102da11b3f49567256867853b861178689671a163d30865c298"
  end

  def install
    # customize liquidctl --version
    ENV["DIST_NAME"] = "homebrew"
    ENV["DIST_PACKAGE"] = "liquidctl #{version}"

    virtualenv_install_with_resources

    man_page = buildpath/"liquidctl.8"
    # setting the is_macos register to 1 adjusts the man page for macOS
    inreplace man_page, ".nr is_macos 0", ".nr is_macos 1"
    man.mkpath
    man8.install man_page
  end

  test do
    shell_output "#{bin}/liquidctl list --verbose --debug"
  end
end
