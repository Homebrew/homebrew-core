class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/f1/19/45b405438e90ad5b9618f3df62e9b3edaa2b115b530e60bd4b363465c704/asciinema-2.4.0.tar.gz"
  sha256 "828e04c36ba622a7b8f8f912c8f0c1329538b6c7ed1c0d1b131bbbfe3a221707"
  license "GPL-3.0-only"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbb7eae66bb3f4258e0e0097409a03942b8c42579b393ffb819c65e70609f947"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8c54e783163691902137e2db879183ea55b677f5d9570726c723d148773d269"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3100dd9b9de99b47ff198cd9b9c9068ae656909f949f59161a3899e5456e3564"
    sha256 cellar: :any_skip_relocation, sonoma:         "917a40df83301b3f5fcaaebbe0d999523b7c931561bb1e3604461824e47aa94e"
    sha256 cellar: :any_skip_relocation, ventura:        "01bdf0637272b5b0b6b6ebcca8499aa6cb4a8f41990fb10a3cd4eecafc099733"
    sha256 cellar: :any_skip_relocation, monterey:       "1c3bdc9b1128c12359a4614831b6513b73ef0e19313c99a77da2081cbb191020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb93ab4fa6cec9f6346eefd2d9ddac8dc5a981a8c946494fa12b5784b5ad669"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end
