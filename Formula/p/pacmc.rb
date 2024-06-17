class Pacmc < Formula
  desc "Minecraft package manager and launcher"
  homepage "https://github.com/jakobkmar/pacmc"
  url "https://github.com/jakobkmar/pacmc/releases/download/0.5.2/pacmc-0.5.2.tar"
  sha256 "b0f4d338779acfb4a8898799beb545beb0a86ce9df19709765a871e33e7f5191"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5491e8b8dc7af3c1bfc4fe1a06bffd1ec87e821380f029262cc40f4abfba9f2"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin lib]
    (bin/"pacmc").write_env_script libexec/"bin/pacmc", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "sodium", shell_output(bin/"pacmc search sodium")
  end
end
