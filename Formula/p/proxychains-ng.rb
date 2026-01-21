class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://github.com/rofl0r/proxychains-ng"
  license "GPL-2.0-or-later"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  stable do
    url "https://github.com/rofl0r/proxychains-ng/archive/refs/tags/v4.17.tar.gz"
    sha256 "1a2dc68fcbcb2546a07a915343c1ffc75845f5d9cc3ea5eb3bf0b62a66c0196f"

    # Backport fix for incompatible function pointer types
    patch do
      url "https://github.com/rofl0r/proxychains-ng/commit/fffd2532ad34bdf7bf430b128e4c68d1164833c6.patch?full_index=1"
      sha256 "86b5db00415bb7d81a8dc1a3d2429ddafbf135090dc67e57620cd18cd71f3b28"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "cfc77a32629806d155490f333305c7f0e063f9c98389192c60d2e6238db4e31c"
    sha256 arm64_sequoia:  "98974765fe2ae812f54eac9b71dfc62814e11bb4cb360a17b4125076c4a0ccae"
    sha256 arm64_sonoma:   "840c1349abf6f4e62edfab1d308e698463deed5a4a8089da31407998bfc819c2"
    sha256 arm64_ventura:  "70b173f39b5c72b9b4bceb2f59c8fa9dff806cb320b1cfe9ecd665a55559b914"
    sha256 arm64_monterey: "f58b8cd85b1e6ce69fdcebcd7c4666f7720e8c8ca773f40a6c27669829cd4fde"
    sha256 sonoma:         "614c2caeb62d41e1de4d4cf4ca346fa16c04dc42f2ff39f19595fcbb3ddb925b"
    sha256 ventura:        "4e7e2b51f1e2def46860b2866342ccb99612d9f711d52a8fd3f99cf92f542264"
    sha256 monterey:       "10937a8845690b9953cc95d30ab8984b1fbe2d5baf6b8b0b602c10579adb8f91"
    sha256 arm64_linux:    "d8fcdce08eb197325b1534e3645916d4966c7facddcea9b3a14f9db258d1c320"
    sha256 x86_64_linux:   "72117ba62cdda573a388e3ba19b52a7991fb941237197f624249a906db414c47"
  end

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
