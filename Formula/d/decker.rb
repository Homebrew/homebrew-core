class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.73.tar.gz"
  sha256 "5d5792f61fa5783133d9893e353c02ee40c345bb8e16a4b43e0a80886f924c01"
  license "MIT"

  bottle do
    manifest_sha256 "173456c731235e967b0c7ad1f747f9ce2e03ff69794a52c82144e213b3de1ad2"
    sha256 cellar: :any, arm64_golden_gate: "0d33bf2120b3cefd0096977f8fb8e073fd0409b538ef59c70b2e99a749f7b5c3"
    sha256 cellar: :any, arm64_tahoe:       "4df5a990b91bd2dbbbcd2440dbbddc72eedad58d73ccf46a5eaf35ffa202b13b"
    sha256 cellar: :any, arm64_sequoia:     "a54ec8b9c6f488431076ba7779504ce189477948c245fb13c06888e113f81eb8"
    sha256 cellar: :any, arm64_linux:       "67d96b6d4429bc6814206609eef8080cbcb1d3600437c6b9638c21eb58d01277"
    sha256 cellar: :any, x86_64_linux:      "a5c37ec835273f2fbdfae7286e54feccc5a2dadab3ea0ff105b2d6db1bb4d9df"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_image"

  on_linux do
    depends_on "vim" => :build # uses xxd
  end

  def install
    extra_flags = "-I#{HOMEBREW_PREFIX}/include/SDL2"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "lilt"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "decker"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    assert_match '"depth":', shell_output("#{bin}/lilt #{pkgshare}/examples/lilt/mandel.lil")
  end
end
