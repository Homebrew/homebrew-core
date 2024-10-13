class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.3.1.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.3.1.tgz"
  sha256 "551130d682c1ed29db4a589fd7302697403a9aa2534c6da982cf8a3dd0265407"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb2d7804426a7348df400a49eb2c0e1bacaa09ff0d7fc376d50891e8fc02a64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d9906726c2c31ab5f0152a0b521de00f08d747118bbc035fb951ed8025fd261"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1d01b299e9e0328083467f236697006813294eac3bbd092bf16173c94f86ff8"
    sha256 cellar: :any_skip_relocation, sonoma:        "006fa58ce07e8dc6031df86157232bbcfe0eaa5e4c2dc59ced2a67b52d031dc4"
    sha256 cellar: :any_skip_relocation, ventura:       "aa1bc99e750988069f0243792a48ec478042a8ad7cd794c757841c62e3fad9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbde1cd30cbeb89f6eab36994c7b7eb5d19186ac5d34a32d5396bc75efe2b769"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
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
