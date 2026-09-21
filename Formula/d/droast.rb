class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.7.0.tar.gz"
  sha256 "5acfdb95d78aa6dbef4ee31abc954aeb7c7a84b6bc6de14307d1e061e583da64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84341dda71e70d036aa6aa7b8823b49640a6256fcf478bf26eeaaf2df69bc81a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4e90e79021e4f044708898eb631dec18cbe88a95748fe5e9691c066811d0f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8170757f11569fec0c06f124701deff67810d4fe2b98ed1f917e53e2b5c92dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fec449fbdebda54b485e67caf1e9cf2bd45c3415ae4b030bd1d0cd3b04e7f90d"
    sha256 cellar: :any,                 arm64_linux:       "39ca98e1a875e9f74dff27dd9f29014a14d3be0c2ed3b36aaf9ea034f00247d3"
    sha256 cellar: :any,                 x86_64_linux:      "0b564b29fc87935061d3135cea4be76db3dbe03c7734512d4c3d67f11b44a7bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"droast", "completion")
  end

  test do
    (testpath/"Dockerfile").write <<~DOCKERFILE
      FROM alpine:3
      ENTRYPOINT ["echo", "hi"]
      ENTRYPOINT ["echo", "bye"]
    DOCKERFILE
    output = shell_output("#{bin}/droast --no-roast --format compact #{testpath}/Dockerfile", 1)
    assert_match "DF039", output
  end
end
