class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.8.0/libatomic_ops-7.8.0.tar.gz"
  sha256 "15676e7674e11bda5a7e50a73f4d9e7d60452271b8acf6fd39a71fefdf89fa31"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b593b16aa8a3ff77e612e68b1be2787c98edf675dfbf31a73af50b128ff17f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed0db8f6667095ba3d496ceed407d24da924b5f5d294c138bb54aac074594990"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7723e54538a406d853548be45f69e2064d79c733cf47e689917132c4156fec2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27c11a727976b29caca9d7971a27ab10ee0aea1708b61e5bc56929e93759793b"
    sha256 cellar: :any_skip_relocation, sonoma:         "af0dd6ab68d21852050444789eadab52f69147c78539ce5c2e771f97be61aa89"
    sha256 cellar: :any_skip_relocation, ventura:        "e6705a2129f65fbc29ae067730e33e4d8fb150774c8a70f20d2fe3506ab26bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "212284fa313db676883d4e7c537ba782f934eb948c9f09921d69c858cdb44c8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0447f302797eb310f879dfd442a8447190df76877274f67dffcf718c7d19a3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a11f2c1002f3b7d07287a8360aa1afb101db94550526d616e74a76bec641b2"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
