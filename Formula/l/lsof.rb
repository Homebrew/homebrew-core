class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://github.com/lsof-org/lsof"
  url "https://github.com/lsof-org/lsof/archive/refs/tags/4.98.0.tar.gz"
  sha256 "80308a614508814ac70eb2ae1ed2c4344dcf6076fa60afc7734d6b1a79e62b16"
  license "lsof"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1e5da9db48640f03adb5bdb7eb23e661d8c37ad2398d56eaac90c6791872c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa116c39661d0d7b685897977dd5d90c384557baeb7dbeef0ab261cc8bd36e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b2be9ee891a5cb62e3e2d68c6513d9a7b27fa414acae729242a1abdbe93135"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90d939a92133f1221f24d45c5406412959aa38aeac6c3a884ba3dc7b9fbf6f84"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f2bc177714cecaf89fe2cda55fb977e99af46b79618dd964e356d916ea24c09"
    sha256 cellar: :any_skip_relocation, ventura:        "0019c79578d74d752cf0589ff83c1b8b21a073327deb58b310ba59e9e46c4b09"
    sha256 cellar: :any_skip_relocation, monterey:       "c33f6a2ff078b538a77c1fa0475b1d409d7196dadfffab16b90d38a13d4ed38f"
    sha256 cellar: :any_skip_relocation, big_sur:        "badaa07907718d5b13096cbfd3654afd65f36dc96ba0f7b382aa8ddd448a689d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb3f15624b78349297ca7a081f14b93a26a7f08d5cb78eda0c268ffbede36f4f"
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
