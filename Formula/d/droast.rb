class Droast < Formula
  desc "Opinionated Dockerfile linter"
  homepage "https://ewry.net/droast-dockerfile-linter/"
  url "https://github.com/immanuwell/dockerfile-roast/archive/refs/tags/1.4.8.tar.gz"
  sha256 "a00af14ce3eb08f8913d2e839265678ce2ad151aeed2b233c1807d6cf69b9347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb015b5804b3a17da6e7b6f6cc77c921700d6484240a952bf5d9bb91d526b52a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b42c568424c17463981c53541421ac2a696fdf5061c8974d142c0bb87bde0bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4e336ef2e8087042ff6d614806c9b43580b61107e49e9ef10329f5abba570af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6c1f47eae13e49eb8d2f9580bbf656c4057e798641e1116cc1bbd178d5ab423"
    sha256 cellar: :any,                 arm64_linux:   "d6c3108c28b6f6ca347ce45edf27c0ef15b9b40347afca4d6023d358bb02ef62"
    sha256 cellar: :any,                 x86_64_linux:  "14b5c9e711aa7d6e17ec3f98e26fdf9dcbfb54a24c682198cae9e33109a20ed1"
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
