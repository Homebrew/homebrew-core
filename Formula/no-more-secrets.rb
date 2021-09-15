class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.3.3.tar.gz"
  sha256 "cfcf408768c6b335780e46a84fbc121a649c4b87e0564fc972270e96630efdce"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f05fcfd3fc3c3cac082c2d0fabb206024fa83e2e834af3102ac6cca44563c612"
    sha256 cellar: :any_skip_relocation, big_sur:       "884cb0503a1014e64fe9d310015c8eafc83f0980fb395da51cf895dd8e40faac"
    sha256 cellar: :any_skip_relocation, catalina:      "0a47f3f151de373eeb54010f4f5fa3db680866f740a25231452852a22fe3477c"
    sha256 cellar: :any_skip_relocation, mojave:        "bf89c9bc341d6dc82bfbb242b6414a2f778b0bc1c26e5f4ced239c649902aad6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ad2927337af4e85d6bff3fbdcfeb2e435c85de8d527d23a3644c7add3c7acab0"
    sha256 cellar: :any_skip_relocation, sierra:        "97ff320dd7639a7a71fbfa4f7e72fb7c66e4b60ea0f6a6adc4583c63cbda05ac"
    sha256 cellar: :any_skip_relocation, el_capitan:    "78c52bd9f179967cb240c8f49763e03e512092ee476b73e38166bfa79757664f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51239498bff84262b53e23cdfc1df4d2d26bea6aa88ee493b3280d3195ddba6d"
  end

  def install
    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
