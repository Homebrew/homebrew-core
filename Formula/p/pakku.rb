class Pakku < Formula
  desc "Multiplatform modpack manager for Minecraft: Java Edition"
  homepage "https://juraj-hrivnak.github.io/Pakku/"
  url "https://github.com/juraj-hrivnak/Pakku/releases/download/v0.8.4/Pakku-0.8.4.tar"
  sha256 "503e66145d3c525056b706b79804d6e741adcd6100714d6af3cd1d9caefc3a89"
  license "EUPL-1.2"

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    (bin/"Pakku").write_env_script libexec/"bin/Pakku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "Could not read 'pakku-lock.json'", shell_output(bin/"pakku add jei", 1)
  end
end
