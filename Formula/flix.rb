class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "e2ab09b2ad3a0f0f2d0a21321bee3532af974b97c7cc265606ddd3b49debbd5b"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9015aee963f7d58f4dce0677c04a706964fecf65545e0d0ec7b53da09900862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bac4879e6cffdcfa94873faaa25f481e5ee79546832bc6e4b0f32c81ffbb1ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "83f6c51f8c09c54bbbcd75505e84fbb2c9f059950d95a81d1823ebdcb19a0b6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f42902e1aaf818daa6c8d24701776c16e39f3a78cfbf71ad27ff66954e23f4c6"
    sha256 cellar: :any_skip_relocation, catalina:       "3c0f792038af23433c1411d6146d6d5a1bd1e40836bc2b6b9792e89261b57a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298c27d19ceb60e94a25e0644650f6235c03233ce9d4b49989bc032f562a8e84"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    system Formula["gradle"].bin/"gradle", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin/"flix"} run")
    assert_match "Tests Passed!", shell_output("#{bin/"flix"} test")
  end
end
