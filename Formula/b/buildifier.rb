class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.2.tar.gz"
  sha256 "39c59cb5352892292cbe3174055aac187edcb5324c9b4e2d96cb6e40bd753877"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d96b28c947998fe37b5fb0a0e00cee1b4ab6b7fc0622ac367e1c6497e9470371"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a533dac86fc075d6f47731cce181be7ab0d8d4c7b8fb1279baffecbcc6179087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d96b28c947998fe37b5fb0a0e00cee1b4ab6b7fc0622ac367e1c6497e9470371"
    sha256 cellar: :any_skip_relocation, sonoma:         "a86261373370b14ff82f7e61067b7305b2f8e49e2643be44f5b48e5897996070"
    sha256 cellar: :any_skip_relocation, ventura:        "23e84c8b339e25f9fe86020216859d6fd48dad62265f7254ba5dacd58bde718f"
    sha256 cellar: :any_skip_relocation, monterey:       "23e84c8b339e25f9fe86020216859d6fd48dad62265f7254ba5dacd58bde718f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715921a64379cb72bcc00d5f2f1787099529f65569a23ebb9868f6496f7ca2b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
