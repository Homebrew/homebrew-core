class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.7.tar.gz"
  sha256 "bac1b0acbc50aede42fc97dffaa0b0475e97973e36a6351de5f349c6155afc68"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d70c25198d50a584362bcf3fa262950f3688a7e1a38f5661c33597438cda2aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aee83daa6e09f430b35cda1095bdb7c94060d9ea3c30c5f3eefbebf44e4f705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc80facd617cce34684707daa32f5cb8be27401119304bfa8a5bf5ae797443ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "edc597507a743085d6e84de313c3c5653b11b33c2f6a2f30d881310632680e2c"
    sha256 cellar: :any,                 arm64_linux:   "5fd75c0e4249d0aafd41d519b6d683506e921bcf34a664f40aad01a9a30547df"
    sha256 cellar: :any,                 x86_64_linux:  "3fe54fc89afd2788f825e86dec6cff5041fcac98c7380ea868db9616279fbc50"
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
