class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.99.7.tar.gz"
  sha256 "bac1b0acbc50aede42fc97dffaa0b0475e97973e36a6351de5f349c6155afc68"
  license "lsof"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14b4cb8fb5459fca28129c2ccca4d432cde66972cd6740daa8a541114280ba9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc185eb6b043833e035449c9fd5020885261bb4eca62435a24fd2f909a6602a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "314ed8a45db599d5edf36093b88bac12430b04408dbd1ccaea7ce19153a97493"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcae085e73be449cd496f1c98fd9807355e23d6bb0df302d4973873c0feaa4c7"
    sha256 cellar: :any,                 arm64_linux:   "943cb2829a6744468af52a7f91bb52cf75a7a5be65fd41ad1281eb85ad20fa19"
    sha256 cellar: :any,                 x86_64_linux:  "b062e49a2df6b0e7133baeffaa3b53a6a0745fe3077a97ee2c8c17ecb7107d19"
  end

  keg_only :provided_by_macos

  on_linux do
    depends_on "groff" => :build
    depends_on "libtirpc"
  end

  # Fix segfault when epoll fdinfo is unavailable, e.g. inside a container
  patch do
    url "https://github.com/lsof-org/lsof/commit/e1f8076051c1adb02fd7c1a4c824e8f373a1ab7a.patch?full_index=1"
    sha256 "dfa5eac284b77ebb932f1b7defaf9d6852e0f97a021dbe2d4e8ae6983f27031d"
    type :backport
    resolves "https://github.com/lsof-org/lsof/pull/368"
  end

  def install
    if OS.mac?
      ENV["LSOF_INCLUDE"] = MacOS.sdk_path/"usr/include"
      soelim = "mandoc_soelim"

      # Source hardcodes full header paths at /usr/include
      inreplace "lib/dialects/darwin/machine.h", "/usr/include", MacOS.sdk_path/"usr/include"
    else
      ENV["LSOF_INCLUDE"] = HOMEBREW_PREFIX/"include"
      soelim = "soelim"
    end

    ENV["LSOF_CC"] = ENV.cc
    ENV["LSOF_CCV"] = ENV.cxx

    mv "00README", "README"
    system "./Configure", "-n", OS.kernel_name.downcase

    system "make"
    bin.install "lsof"
    (man8/"lsof.8").write Utils.safe_popen_read(soelim, "Lsof.8")
  end

  test do
    (testpath/"test").open("w") do
      system bin/"lsof", testpath/"test"
    end
  end
end
