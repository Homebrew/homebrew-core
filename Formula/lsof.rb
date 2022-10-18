class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.96.4.tar.gz"
  sha256 "b5a052cac8d6b2726bbb1de2b98c6d9204c7619263fb63e9b6b1bd6bbb37bf14"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c6dce4f448d166e1588a944d0dd3ca5ad402371a665b7dbc5020a2479b551e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed91f788498429ebb4ed4cc1fa544d47b9c57bdf962302c9ef161b0d5660b09b"
    sha256 cellar: :any_skip_relocation, monterey:       "26f22fc4df1974bb1066a40aa1c3f13cb0800530c06c08060a0c35554e617c5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "47fa3e6049ce65e694409c6b37f683c33c6dadc0dda30d3f2450fc9e5eb0f6db"
    sha256 cellar: :any_skip_relocation, catalina:       "dc9bce7d117ff773df8c1bc431685f2e5c4c8e380ac688d1d8144000ffc95fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f296ae44ad1a92009ffc94989c49c34410bbc23eb852d7cad4e436837ee9c21d"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace %w[
        dialects/darwin/kmem/dlsof.h
        dialects/darwin/kmem/machine.h
        dialects/darwin/libproc/machine.h
      ], "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    man8.install "Lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
