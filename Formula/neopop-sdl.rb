class NeopopSdl < Formula
  desc "NeoGeo Pocket emulator"
  homepage "https://nih.at/NeoPop-SDL/"
  url "https://nih.at/NeoPop-SDL/NeoPop-SDL-0.2.tar.bz2", using: :homebrew_curl
  sha256 "2df1b717faab9e7cb597fab834dc80910280d8abf913aa8b0dcfae90f472352e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2e05cd5ba9c3f61c061bff01607a5fca678439b287e0ad052bfc4a4ec142f3e1"
    sha256 cellar: :any,                 arm64_monterey: "75d72c03b2f65fedee641b74515ebbbc021009d7ac281f284b48d6eca1ff145b"
    sha256 cellar: :any,                 arm64_big_sur:  "8ec87c1aa5a6544628143aff2edc8b0db59185b2998c1e7f14a9f3490db3c991"
    sha256 cellar: :any,                 ventura:        "583778caac90e4d3e9ae9f0fed5c2610ea46edd041684cc39ac23f95b531bba9"
    sha256 cellar: :any,                 monterey:       "7a07a0dc510ed83c174dd54ad3a0a8005dce9e9c2be44b61b622a455f9a9bced"
    sha256 cellar: :any,                 big_sur:        "ed8e6cb23919f63c24ff387d81b531e1e64af40387d2f60b7fc751bfd8141e04"
    sha256 cellar: :any,                 catalina:       "6b988af217b9dc042b17495a45d2f9ec7481025d941e31a749d798e4039d2f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "742ad78adc9f2c1ec32c9221406e52d4656321c7ba16836c7e630469e3b6a26c"
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
  depends_on "sdl12-compat"
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
