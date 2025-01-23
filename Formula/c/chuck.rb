class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.4.4.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.4.4.tgz"
  sha256 "a85b06fe555e80f8ef66dd339bf03ee51b46b3d24bfdf70d56a7487236cdf771"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775bf00f05b209536fafb9545cdcbe51c0da3d716566b975e192db2c6d739b60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327ed6c159ebd35647b90743e5406f42d93ccae78d885ae630a820de808e9da3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "488ee8960fbbc51c09970551c77df30832c8717000a860dda9887ca2e66ce1c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc3990012ae2a5e68b85532d3ce490bbea0a4e7f8f4827b97998956201aba58f"
    sha256 cellar: :any_skip_relocation, ventura:       "412634f85e469d3918b11fe631623729e179242fce929914111cb61fa60adef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2694e0c7f57dc9dc4f7613cde9e7bc8d082168cad05ab4387969b80a352ff7d0"
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
