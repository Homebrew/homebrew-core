class Lorem < Formula
  desc "Python generator for the console"
  homepage "https://github.com/per9000/lorem"
  head "https://github.com/per9000/lorem.git"

  stable do
    url "https://github.com/per9000/lorem/archive/v0.8.0.tar.gz"
    sha256 "3eec439d616a044e61a6733730b1fc009972466f869dae358991f95abd57e8b3"

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
