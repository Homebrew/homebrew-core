class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.3.tar.gz"
  sha256 "b9c56468b927d9691ab168c0b1e9f8f1f835694a35ff898c549d383bd8d09bd4"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16ebd7a5811316080caab9d8c4a78edaca53b03a99cbf5f097374276ec765cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dfd73c75338d29b2ca1200367012c71ff4c0f60aa209f646f18f37b467928bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5133599dd0cef604aa86392ce6127abb0a25b27502b6de91df7a194fa5fb7b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea99d238b7d54109b44bb497170ac2b7f137c8a44e93d5b683e1f46013ea707f"
    sha256 cellar: :any_skip_relocation, ventura:        "da2c7415df80ffc5bed01cb5e89c60018da1ce5723daf110fb0ae08df56df32c"
    sha256 cellar: :any_skip_relocation, monterey:       "0e9f173fd9e746145c3d9a00c6a233a0c3b17a7c3d079ddf831d739924df99f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f1de8814554f973dc04ccfde44d4b685b35957984566d4ae82d8f8dce58e22d"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "libtirpc"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"

      # Source hardcodes full header paths at /usr/include
      inreplace "lib/dialects/darwin/machine.h", "/usr/include", MacOS.sdk_path/"usr/include"
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
