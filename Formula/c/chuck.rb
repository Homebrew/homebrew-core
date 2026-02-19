class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.7.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.7.tgz"
  sha256 "73c1391b9064fd06a5646b1c18b2b991b6cad6d98c3f893a0d10bae1ece44c8c"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739dc60aaf4b4c565ea6bac04e540910a26844e8ddc67ef0892745adfb3c6f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f8382ce743d2b2badd0ce6fd744b1828d7621361d16ac4cb270fafd0d8d639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a109184ef976411947fcf21f435517d0ee433d23f84a97a4550b427d14cfc2b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "680e5d7d7b1b0ff75269e81b947303ae48f7bedc1fba7225417f3a07616b0202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6e3c18bd45e87ec2ada4a5415cf45d6ac1ac97eea28de0fb5868f16c4d593b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc96c971bccbabf7fc2e4d49cb6b8a878c957d7b7e0aed8361dbf9ecafcd60b0"
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
