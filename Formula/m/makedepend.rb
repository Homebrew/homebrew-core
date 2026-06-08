class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.9.tar.xz"
  sha256 "92d0deb659fff6d8ddbc1d27fc4ca8ceb2b6dbe15d73f0a04edc09f1c5782dd4"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "bcbae90cda88768f019767a02e2311d80b3425308893a30acdefe9553b4448ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9b0e3a47a0d4bf48d695e8e2cb8353cc49acf3cf470f45b3b1ba48d049cdb190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "065db2cad1fdc8a5da5cb54ff2ed60820fa3db8c5d0a643b99e46769ca1d89c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90aefc577a198b25cdd9d0ac5e873b3d33741416db9dcdcc3277664af8c07fad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e7994da9aa7cc77c32388b041bb3dabd5885dbfc0e9d88e890289ec71853ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6874f996ef7a5687bf1f83a0f1697c0e8360b4dda635b18be0926411dfabb7a"
    sha256 cellar: :any_skip_relocation, ventura:        "9b32d643af15de0c40854c16e50b5f6c5972825156d58b5fc03433cc1c4b63c8"
    sha256 cellar: :any_skip_relocation, monterey:       "febb3e4989051d186f36914a7df4ce155d52784a5a9d702a8c81ef6cc34d0e6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d285353719e76dfc8b61c138d72ed14b3e3167b3aeb817a3dfd5b2a6710250a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3513c65618644fc944f76db3cb1975f843d82eaf6198d58770c23ee145c1efed"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros"
  depends_on "xorgproto"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    touch "Makefile"
    system bin/"makedepend"
  end
end
