class Pacmc < Formula
  desc "Minecraft package manager and launcher"
  homepage "https://github.com/jakobkmar/pacmc"
  url "https://github.com/jakobkmar/pacmc/releases/download/0.5.2/pacmc-0.5.2.tar"
  sha256 "b0f4d338779acfb4a8898799beb545beb0a86ce9df19709765a871e33e7f5191"
  license "AGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9d54abfccc300901396d32f398dd0560690dca1f3414ed70a66156924ea8397f"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[bin lib]
    (bin/"pacmc").write_env_script libexec/"bin/pacmc", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "sodium", shell_output("#{bin}/pacmc search sodium")
  end
end
