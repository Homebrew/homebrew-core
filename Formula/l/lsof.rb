class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.4.tar.gz"
  sha256 "90d02ae35cd14341bfb04ce80e0030767476b0fc414a0acb115d49e79b13d56c"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036464108e88a5a4dad168d55f6723cba3d08596af58cebf3ade61aefea71483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50c9dfb75c471b274c2511d0f58991ef9322e55767cc0aab21c5498a79a1ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d4db66c9789321451d318f624429d10ecb8eb4e6a6f8673a7cfa77d0417901"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b39fb2ccf6675270d8c3ab4e4e28b25622b5416b6772e53c59bb8c49f72bb06"
    sha256 cellar: :any_skip_relocation, ventura:       "140084e5e184dc4a3543bee49fb67183a440c998d28c8f9c1ac3089b02f557f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e24fc77e7ff568fda5a3a5bc1866c763b99949d5cafed8e01f33dfb10028d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "888180a7668c87bd0f636a1c3699e4221c1fcf2ffc9def34538f7687def47a09"
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
      system bin/"lsof", testpath/"test"
    end
  end
end
