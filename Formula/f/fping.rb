class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-5.3.tar.gz"
  sha256 "d57bd0141aea082e3adfc198bfc3db5dfd12a7014c7c2655e97f61cd54901d0e"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?fping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34826c963fd624266f511d3fb0dd26b610b8843cebbb16f31220e43c20a4052b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec5e5ab2337affbf9f5fe26ba7a69b55e10f18a0a0065bf0b54eab0847265a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "658575a36018fa71348dea5d451069d336b152344bedb9fcc6e3bc33ca9a5283"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a1ba89c185ab398f0331f79ffbd47a6f810fc8f7e3e25bedcb2022add56eeb5"
    sha256 cellar: :any_skip_relocation, ventura:       "784590da34854b738fe5ea0470d518a23576496dc7cddf49102940ba78ff1ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ad8e2a81facd122c8625f7389a2d1d32643c2587c85bf1c0b891d7936fcfea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89675f5ea6956c4e188fa9c4ea28b72a951a5ee899d4f06b29e1275dd47a6952"
  end

  head do
    url "https://github.com/schweikert/fping.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fping --version")
    assert_match "Probing options:", shell_output("#{bin}/fping --help")
    assert_equal "127.0.0.1 is alive", shell_output("#{bin}/fping -4 -A localhost").chomp
  end
end
