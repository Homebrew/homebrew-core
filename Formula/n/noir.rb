class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "25660741e04a7c4e617fcb1fbfdbb85568665b13126325bde58545dffda7a935"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "e3e0aea93180ad6c17586b9fdbd18d46030c5ccc5b1a3e08015e2defc9854a98"
    sha256 arm64_ventura:  "6d79212ecde378b11c0516de1aa4e2464fdb284297d7aa23f13e8abab8c2b837"
    sha256 arm64_monterey: "3a5d83a6bc7bae7a9df89d671c632697dc6cfef4b23256e0d494499ca711e0c7"
    sha256 sonoma:         "bbfb2385c72f42c00d647a53a9d88887e3b111dd57eea5522b4a51d895e2f641"
    sha256 ventura:        "923d43e89055f9b897d27375eed01c1843efa9f28c678b4a0fd4e222eadf2af8"
    sha256 monterey:       "a5e1b7834ced253142990eafd127efbdb6d0ac6405f617799c5e47cd3d3aab9d"
    sha256 x86_64_linux:   "cd43d001d4e455a8871f81edfa9569d7d6ec3f79ef2815c2601cfc1b53e4daed"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
