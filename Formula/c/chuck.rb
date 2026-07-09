class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.8.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.8.tgz"
  sha256 "d230f74cea1b0454ccfae4b2fedfb27ea20e6250c7130f079fa4195fef1f304a"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90aeecdbdb811c2f2d5b81330c91530dee442875ede789dcff5ac8182d9e0495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b066b058cb643f831f78464115db90ecbd0c38a7d39af42e70d3b3b9bd3d23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36a5216af60b0326a886724ea824921d96c470cd7927fc18d256e23d1efd2a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "16ae1612c06080d613ce793a60fea3e71436c3a1132d2c5ff2262be682379d24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e1f30b7cd0e5f21f477fa2f24ca9499dbd67500af8c9bf1a8d62ce0f8ac5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9c83b1a3ea0b9064ffbbfec30225f1e3ba8b2dbfd99e9d4c3e02a96d9763017"
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
