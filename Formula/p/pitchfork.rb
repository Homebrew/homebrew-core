class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "f50289c0898bf1bda57a625bab89c2ec3964d6c34e6445c19113cf9e9c09f21c"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e87de880562cb38938307a62ee659906d5e2120743d97f29ebec67dcdfb56c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29224f196a7443b3cf5fa1baca4adc8458a5ab73ee5295ca2c70e521968e2f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4a22d71ffb1c705ff3d3d8bc218092a020045ad2188b82411d2bb680a7c5e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe1108495fa82376808d1ab83c75cb25aa6ae4b081aa645cde7824df57b63d2"
    sha256 cellar: :any,                 arm64_linux:   "870b59792df36bca68fb784bac2e2d2a0471e411b9fc5233c57f3e8d6ff0bdf8"
    sha256 cellar: :any,                 x86_64_linux:  "3c4bf5da69c8d51b702350c11e3efdd8712bcab7bd1418fba77cca53cfb186af"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end
