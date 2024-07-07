class AudioVisualizer < Formula
  include Language::Python::Virtualenv

  desc "Janky, yet charming, terminal audio visualizer"
  homepage "https://github.com/gituser12981u2/audio_visualizer"
  url "https://github.com/gituser12981u2/audio_visualizer/releases/download/v1.0.1/audio_visualizer-1.0.1.tar.gz"
  sha256 "82f089e3d50e61329d8811cf14be4c80036d24c110b50b9a8a23a07aec8abed7"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "python@3.12"
  depends_on "six"

  on_macos do
    resource "pyobjc-core" do
      url "https://files.pythonhosted.org/packages/b7/40/a38d78627bd882d86c447db5a195ff307001ae02c1892962c656f2fd6b83/pyobjc_core-10.3.1.tar.gz"
      sha256 "b204a80ccc070f9ab3f8af423a3a25a6fd787e228508d00c4c30f8ac538ba720"
    end

    resource "pyobjc-framework-ApplicationServices" do
      url "https://files.pythonhosted.org/packages/66/a6/3704b63c6e844739e3b7e324d1268fb6f7cb485550267719660779266c60/pyobjc_framework_applicationservices-10.3.1.tar.gz"
      sha256 "f27cb64aa4d129ce671fd42638c985eb2a56d544214a95fe3214a007eacc4790"
    end

    resource "pyobjc-framework-Cocoa" do
      url "https://files.pythonhosted.org/packages/a7/6c/b62e31e6e00f24e70b62f680e35a0d663ba14ff7601ae591b5d20e251161/pyobjc_framework_cocoa-10.3.1.tar.gz"
      sha256 "1cf20714daaa986b488fb62d69713049f635c9d41a60c8da97d835710445281a"
    end

    resource "pyobjc-framework-CoreText" do
      url "https://files.pythonhosted.org/packages/9e/9f/d363cb1548808f538d7ae267a9fcb999dfb5693056fdaa5bc93de089cfef/pyobjc_framework_coretext-10.3.1.tar.gz"
      sha256 "b8fa2d5078ed774431ae64ba886156e319aec0b8c6cc23dabfd86778265b416f"
    end

    resource "pyobjc-framework-Quartz" do
      url "https://files.pythonhosted.org/packages/f7/a2/f488d801197b9b4d28d0b8d85947f9e2c8a6e89c5e6d4a828fc7cccfb57a/pyobjc_framework_quartz-10.3.1.tar.gz"
      sha256 "b6d7e346d735c9a7f147cd78e6da79eeae416a0b7d3874644c83a23786c6f886"
    end
  end

  resource "lupa" do
    url "https://files.pythonhosted.org/packages/b6/13/3a0d2c231ae39bced22f14ded420915be1b88f030bfd2388900d89a74a4b/lupa-2.2.tar.gz"
    sha256 "665a006bcf8d9aacdfdb953824b929d06a0c55910a662b59be2f157ab4c8924d"
  end

  resource "PyAudio" do
    url "https://files.pythonhosted.org/packages/26/1d/8878c7752febb0f6716a7e1a52cb92ac98871c5aa522cba181878091607c/PyAudio-0.2.14.tar.gz"
    sha256 "78dfff3879b4994d1f4fc6485646a57755c6ee3c19647a491f790a0895bd2f87"
  end

  resource "pynput" do
    url "https://files.pythonhosted.org/packages/d7/74/a231bca942b1cd9c4bb707788be325a61d26c7998bd25e88dc510d4b55c7/pynput-1.7.6.tar.gz"
    sha256 "3a5726546da54116b687785d38b1db56997ce1d28e53e8d22fc656d8b92e533c"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12", system_site_packages: false)

    puts "\e[34m==>\e[0m \e[1mThis might take a while.\e[0m"

    resources.each do |r|
      puts "\e[32m==>\e[0m \e[1mInstalling \e[22m\e[32m#{r.name}\e[0m"
      venv.pip_install r
    end

    venv.pip_install_and_link buildpath
    puts "\e[32m==>\e[0m \e[1mInstallation completed\e[0m"
  end

  test do
    assert_match "audio_visualizer 1.0.1",
    shell_output("#{bin}/audio-visualizer --version")
  end
end
