class Lorem < Formula
  desc "Python generator for the console"
  homepage "https://github.com/per9000/lorem"
  version "0.7.4"
  head "https://github.com/per9000/lorem.git"

  stable do
    url "https://github.com/per9000/lorem/archive/6da0a5ac4dcce0e2463a0d820baafde72210fbff.tar.gz"
    sha256 "bb103552d6532e4e0276a936b9cec02ceffd5dce56325f2bf53fed8203a26ae1"
    # Patch to fix broken -q option in latest numbered release
    patch do
      url "https://github.com/per9000/lorem/commit/1e3167d15b1337665a236a1e65a582ad2e3dd994.diff?full_index=1"
      sha256 "151234f4d75d1533b98d1c0f4cb75ab5b2d51eef12586a1c83ad5376f3dadd60"
    end
  end

  bottle :unneeded

  def install
    inreplace "lorem", "!/usr/bin/python", "!/usr/bin/env python"
    bin.install "lorem"
  end

  test do
    assert_equal "lorem ipsum", shell_output("#{bin}/lorem -n 2").strip.downcase
  end
end
