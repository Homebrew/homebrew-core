class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/f1/19/45b405438e90ad5b9618f3df62e9b3edaa2b115b530e60bd4b363465c704/asciinema-2.4.0.tar.gz"
  sha256 "828e04c36ba622a7b8f8f912c8f0c1329538b6c7ed1c0d1b131bbbfe3a221707"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5ecbcebc62f27a2078b240921060282cef4507a007db5aabfc850c36aea51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5ecbcebc62f27a2078b240921060282cef4507a007db5aabfc850c36aea51a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f5ecbcebc62f27a2078b240921060282cef4507a007db5aabfc850c36aea51a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c106a9e92ab1af2710d651a1453d8abc70d1a677507e2d28c0b11a277da3180"
    sha256 cellar: :any_skip_relocation, ventura:       "1c106a9e92ab1af2710d651a1453d8abc70d1a677507e2d28c0b11a277da3180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee91d0aae8818e3fe011ebd01134f75f180eee8e3332a49d2aef719295e85a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5ecbcebc62f27a2078b240921060282cef4507a007db5aabfc850c36aea51a"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end
