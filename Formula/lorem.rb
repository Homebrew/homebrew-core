class Lorem < Formula
  desc "Python generator for the console"
  homepage "https://github.com/per9000/lorem"
  revision 1
  head "https://github.com/per9000/lorem.git"

  stable do
    url "https://github.com/per9000/lorem/archive/v0.7.4.tar.gz"
    sha256 "7917f4b8ead5209ddb44c395955dcc276ea63a81d8a416b5d0a5ef8f545bf81a"

    # Patch to fix broken -q option in latest numbered release
    patch do
      url "https://github.com/per9000/lorem/commit/1e3167d15b1337665a236a1e65a582ad2e3dd994.diff?full_index=1"
      sha256 "151234f4d75d1533b98d1c0f4cb75ab5b2d51eef12586a1c83ad5376f3dadd60"
    end
  end

  bottle :unneeded

  def install
    bin.install "lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}/lorem -n 2").strip.downcase
  end
end
