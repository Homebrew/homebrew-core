class FridaTools < Formula
  include Language::Python::Virtualenv

  desc "CLI tools for Frida"
  homepage "https://www.frida.re/"
  url "https://github.com/frida/frida-tools/archive/5.3.0.tar.gz"
  sha256 "45033ff6edbabb2b11e8b7198e5d2ee865fc616386d1adc735039bf8dd0302e9"

  depends_on "python"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz"
    sha256 "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d"
  end

  resource "frida" do
    url "https://files.pythonhosted.org/packages/7d/27/69bc3f09b52241b2d890c8fdbb54bf8cf85817f3c23146cadd841a876fde/frida-12.7.22.tar.gz"
    sha256 "b8a06bbac5f18b978f0a4154a72d29ceeb28b7c08840ea553d517d165c1526b3"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/0c/37/7ad3bf3c6dbe96facf9927ddf066fdafa0f86766237cff32c3c7355d3b7c/prompt_toolkit-2.0.10.tar.gz"
    sha256 "f15af68f66e664eaa559d4ac8a928111eebd5feda0c11738b5998045224829db"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
    sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    output = shell_output("#{bin}/frida-ps")
    assert_match "PID  Name", output
  end
end
