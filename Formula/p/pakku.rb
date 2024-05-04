class Pakku < Formula
  desc "A multiplatform modpack manager for Minecraft: Java Edition."
  homepage "https://juraj-hrivnak.github.io/Pakku/"
  url "https://github.com/juraj-hrivnak/Pakku/releases/download/v0.8.4/Pakku-0.8.4.tar"
  sha256 "503E66145D3C525056B706B79804D6E741ADCD6100714D6AF3CD1D9CAEFC3A89"
  license "EUPL-1.2-or-later"

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    (bin/"Pakku").write_env_script libexec/"bin/Pakku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "Could not read 'pakku-lock.json'", shell_output(bin/"Pakku add jei")
  end
end
