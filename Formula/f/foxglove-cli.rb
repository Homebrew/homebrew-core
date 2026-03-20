class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.30.tar.gz"
  sha256 "e467923c569ab0b0ce591dd926510fa02ef7d7f123576250072fe332752eb811"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3670dd5a7baedface0646dc382a71084d698f7dfbee71cfe1555b8f08bd3e046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e830576a1b286653b9e7618a5951ba3738063c1b4bd0d466c8770a548863320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "501e11f6931baaf085c380c5c8a0c8a6fd88aa16e9396a3dbff6208b7eb26dec"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d90a49e83e65f820c32724381706fb438255839b1370aab399b77c034d15921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ef571f5552dc401107f64b27b5f63769098390b49440ac3fcfffb3a0e3d40c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb6bd51c9bf36575dd3e8bb96087f6b91376bff02519f4d031198a22dec249d"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
