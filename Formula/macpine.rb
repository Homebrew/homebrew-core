class Macpine < Formula
  desc "Lightweight Linux VMs on MacOS"
  homepage "https://beringresearch.github.io/macpine/"
  url "https://github.com/beringresearch/macpine/archive/refs/tags/v0.7.tar.gz"
  sha256 "47777dee26c6c9c0d0683e9e6b0d8dd85b20c1336cbeffaa9f1be0b6fcedf8d7"
  license "Apache-2.0"
  head "https://github.com/beringresearch/macpine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0359c65c076d0e060e791bec4c066ec97168622e16901735f8eff5c6d30bf97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b5b16afe5fa16d83e28d0bb40f9da10ab38192f290fbf9e961f50bef0bafa7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbbece12d9b3e3902080ad53fdee339506fa1ed27e077adc91681413e35a6d65"
    sha256 cellar: :any_skip_relocation, ventura:        "5826f990301bf0a20b90fbeeaef0bb9bdca6634257a2ded8e7503107255963aa"
    sha256 cellar: :any_skip_relocation, monterey:       "3d50502aadab956d2fbce0b3371eae5b206f6ee909478bec4636a10b7c7d4bb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "aabc1160c360c19da0ba7476755c4c72593ed3f5eb0a1452c665c7049cbe9559"
    sha256 cellar: :any_skip_relocation, catalina:       "6dc1ed5e5ad09ed9353b9fd37ce7aea7914c353c470357397eaf2d48296714cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0f893f2ff0b6d5cb7da262de069692ce3e74f7bee01088efebf973bd2324bf"
  end

  depends_on "go" => :build
  depends_on "qemu"

  conflicts_with "alpine", because: "both install `alpine` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "NAME OS STATUS SSH PORTS ARCH PID", shell_output("#{bin}/alpine list")
  end
end
