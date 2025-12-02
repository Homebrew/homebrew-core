class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/a6/ee/8ff0180dc5aab1f6fe59aeb66e2eaea20b0dfbc94f3d40ac5047eaf89579/dotbot-1.24.0.tar.gz"
  sha256 "f2d35eb0a367d1c81d0cd84fcacd1930c64afcbd17013702852a7ee9c104fb65"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a40f62aa621daccfe4a1a40c39117876eeac862a9d95e079b5ed1817bc633f68"
    sha256 cellar: :any,                 arm64_sequoia: "cc0da0c4f520eb535c8267f7a94f44e508b68165d363f92f5d4d75af93ffad5b"
    sha256 cellar: :any,                 arm64_sonoma:  "e93677b6e8c350f53ef70d95c6e27b8e447d4d994e102f528f0cc98661878cf0"
    sha256 cellar: :any,                 sonoma:        "0a7973e810721b5b016729e597f638cd85898bd59ef6195400edeace22c5ec18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7779c8acc1f27d91a99a80eb5ab9eb49101b3b9df09364569f910f06d8c256db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf9c4b4b11dd4993d6e921804063729f7e004a2cc00b6b33dd2ddc87d555372b"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~YAML
      - create:
        - brew
        - .brew/test
    YAML

    output = shell_output("#{bin}/dotbot --verbose -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_path_exists testpath/"brew"
    assert_path_exists testpath/".brew/test"
  end
end
