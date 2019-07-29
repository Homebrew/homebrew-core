class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.16.0.tar.gz"
  sha256 "f4291dc053864b81c10dc1e9f9220aee3d4ce7ef735ecdb70de9ecbf6e0aaa5b"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5666506f7e828fc52155be88f400b0f6c705f5aea9b0eff1512fd84254ce2da" => :mojave
    sha256 "109dae11171e62d331b4a7f2837e1ca3ffa659d2a1c89561b91c54d3aeea537e" => :high_sierra
    sha256 "87a8e09164668b76554cb9fae60645bdb5b1364ff1813147a59db55e08cc9d5b" => :sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"
  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
