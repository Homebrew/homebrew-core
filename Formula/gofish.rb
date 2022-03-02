class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.0",
      revision: "691768d1a77f2adb3e57271cddf6fea31cc6dadf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d879c6dd357bd178ffb161803bd0e6626a7bc75dff054b535a4336aeac4ad2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d92c1849719ea381570b7c62067ec452eaf6fc9bfe5d26a948012ce226f1c9d8"
    sha256 cellar: :any_skip_relocation, monterey:       "09cee8ca50085af3d6892697f3cf0598f47eec3470e3741881a527e5e438322d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f860c600c7319d12ab83f32ddb9b4ddfb4217af80a49a3e77ee0b5db7901719d"
    sha256 cellar: :any_skip_relocation, catalina:       "3f039b3d2118be9f07571c23ebca418bbdfed67cd30a775651fa6af142be8665"
    sha256 cellar: :any_skip_relocation, mojave:         "a80b48b522048d266fa8d265d7901cb249fa15e43149deb3bfe24917a746edce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "757fbd2b35c402ecaa216f7a0c566b10a632483e62718c39204c22d5d7b7b467"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
