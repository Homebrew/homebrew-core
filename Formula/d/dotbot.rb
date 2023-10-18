class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/04/8b/0899638625ff6443b627294b10f3fa95b84da330d7caf9936ba991baf504/dotbot-1.20.1.tar.gz"
  sha256 "b0c5e5100015e163dd5bcc07f546187a61adbbf759d630be27111e6cc137c4de"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56a2f53577f48db57ae4bb8885ff6b470bd29fffa41177029ad8662c024acefe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d50c52618551450b7594924d815cfcc7899e3493443898712edc7573136061f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "839386908832b06ad3c07a7da606af27b79c92a4a8f37e8698a20b07901d9c46"
    sha256 cellar: :any_skip_relocation, sonoma:         "be87ec9a1d6c7187b85cf18d3b41b1d370336b7a8a2f0f72681809d72ea51055"
    sha256 cellar: :any_skip_relocation, ventura:        "556aa8e922e4bc658818c49979911bdaae9a7627c20da31aa06deea712e8d508"
    sha256 cellar: :any_skip_relocation, monterey:       "2ea796e22d1dd2fd4c684da856a09c4e161db850d791b2e1143394b480e75d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796780e6dcf6223bda3076d05d5f52fb022491bcfd99b7ddc73676b42ce5935b"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~EOS
      - create:
        - brew
        - .brew/test
    EOS

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end
