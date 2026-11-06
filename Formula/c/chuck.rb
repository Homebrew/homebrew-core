class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.9.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.9.tgz"
  sha256 "b3e9f3e752d2c7a8d3eb9f359c70fc624de12a2278b3facdffb902439fa3943c"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "149f6fe10c4f133fa16ec756fd186abfd15c50a03398722e74669979cfc5f1cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a664c0fecf1dc40ab6f619e059ed14a670fb5b1a50576a8ed0a3bc077877e00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff275e1d82d708ea475783ebc541d9e1c6be6d834bc97aba682e8ff57f1d0c9f"
    sha256 cellar: :any,                 arm64_linux:       "957e3c72739883c8fa5cb8b52c25ba7f5b016d557bd204ccf01e06db7279cf8c"
    sha256 cellar: :any,                 x86_64_linux:      "2896e86057d198488191634fae660befd6d66027e9a1c404dceaa2305142e638"
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
    (testpath/"test.ck").write("<<< 2 + 3 >>>;\n")
    assert_match "5 :(int)", shell_output("#{bin}/chuck --silent #{testpath}/test.ck 2>&1")
  end
end
