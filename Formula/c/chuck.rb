class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.5.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.5.tgz"
  sha256 "7f16d35b4c1c2a7d6aea9b1186109eea91c52533c57d95130a6946afb805a115"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c746d03444877cf75da06d1e1b2d95a4ff42bad0f5ffee77f1e51e6405a9f7ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb510c4471835f9aa3c4aeec20ec28622ae84ed148328e0bc1efd27c7468cc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8144f55c7d4f24572be41c4fbce7100c2f34cc7d51e7903c276e667fe5c9f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5b88313214f020e0fd3c5506a60194ec1710738c040eca7dc7a19e808822074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f41b03c808cbc565f640814a0fb66efc3dfc44ed0a3f156fe933edcdf0ed7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab6fc6fa3ba97bc03f9540b6b383182b0cca6c23bf550f4ffdaab813af2621ac"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "libsndfile"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
