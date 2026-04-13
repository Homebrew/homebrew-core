class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.7.0/hamlib-4.7.0.tar.gz"
  sha256 "24542b09cb2432458ba239b2ba8f5b7fb67cde64df6553f150e6eb8475a87a23"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "795fb006175fc13444cf579440e6e125ac2b93f663eb91e465575ad928efb8b2"
    sha256 cellar: :any,                 arm64_sequoia: "797eacb1d1c19c05626d504f2fc89d3879ff0815edad0a7fc5dd9bbbdebe6535"
    sha256 cellar: :any,                 arm64_sonoma:  "cd7a308c3b60fd7eb35050f53d6d594c4aa396c882764d9de35ac377db85de8a"
    sha256 cellar: :any,                 sonoma:        "07a248953520ac1cb124b0c2658c8c09be0368263978a72af2a0cb0bcae3e621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03dd51b236f22b14d4c4facdba2785626461b158f6b9cf5efec2dbfecbebc6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe36a3eb41674900111dd9754872026ced061dd66447d5e932fc7fd153e511eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end
