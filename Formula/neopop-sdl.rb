class NeopopSdl < Formula
  desc "NeoGeo Pocket emulator"
  homepage "https://nih.at/NeoPop-SDL/"
  url "https://nih.at/NeoPop-SDL/NeoPop-SDL-0.2.tar.bz2", using: :homebrew_curl
  sha256 "2df1b717faab9e7cb597fab834dc80910280d8abf913aa8b0dcfae90f472352e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 monterey:     "735c39be0cdfe7a56e4d395859d097b9a48dbea26b219bf922cdddb3ffa5e40f"
    sha256 cellar: :any,                 big_sur:      "53e2a47e1f4e3bc4b35a31ea06f757ef62fc11de24347fcca5f4d1799f1adf94"
    sha256 cellar: :any,                 catalina:     "c4bd22db58945139a07d7c007c546e2edb3be1c3763f2d3f3008b575f30cef84"
    sha256 cellar: :any,                 mojave:       "d84d1d9e2304a21ce915b8a65001a310da3c797e1f89e4d8a86a102e53f92f10"
    sha256 cellar: :any,                 high_sierra:  "9bdf06235151ae52d85e630021ce810d49ce12ba74e18b27f7584d9584377eb4"
    sha256 cellar: :any,                 sierra:       "3510d31984f2f46a59390617e2af3941638a4eb20a42131fc804e5d307cb5059"
    sha256 cellar: :any,                 el_capitan:   "e115fe849a0b8e1921a6c36c3d34fcc00b911f0504a0e32543656e76513384ad"
    sha256 cellar: :any,                 yosemite:     "a8de30162f9e5146ee7c39480e83588f8036c0b965215e7ce1894c79855c8687"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53a84ba836a1c4f2ce579d149554a865e69a736ec69e6c49de369dd5f0364673"
  end

  head do
    url "https://github.com/nih-at/NeoPop-SDL.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "pkg-config" => :build
    depends_on "ffmpeg"
  end

  # Homepage says: "Development on this project has stopped. It will no longer be updated."
  deprecate! date: "2022-04-02", because: :unmaintained

  # Added automake as a build dependency to update config files for ARM support.
  depends_on "automake" => :build
  depends_on "libpng"
  depends_on "sdl"
  depends_on "sdl_net"

  def install
    if build.head?
      system "autoreconf", "-i"
    else
      # Workaround for ancient config files not recognizing aarch64 macos.
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # Test fails on headless CI: "cannot initialize SDL: No available video device"
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && OS.linux?

    assert_equal "NeoPop (SDL) v0.71 (SDL-Version #{version})", shell_output("#{bin}/NeoPop-SDL -V").chomp
  end
end
