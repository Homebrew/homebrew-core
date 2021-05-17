class MacosUpdater < Formula
  desc "simple updater tool for macos. checks any updates from homebrew, macports, pkgsrc, nix, any native application and the mac app store, and install them."
  homepage "https://github.com/dindin-glitch/macos-updater"
  url "https://github.com/dindin-glitch/macos-updater/archive/1.0.3.tar.gz"
  version "1.0.3"
  sha256 "57fd626a153a6dfdeebb6dc1133910f8ea5837435be9e32b3f77358cd6ea8362"
  license "BSD-2-Clause"

  # depends_on "cmake" => :build
  depends_on "mas"

  bottle :unneeded

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method
    # system "./configure", *std_configure_args, "--disable-silent-rules"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "chmod a+x configure"
    system "./configure", "#{bin}"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test macos-updater`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "macos-updater"
  end
end
