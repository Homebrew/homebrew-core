class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.5.1.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.5.1.tgz"
  sha256 "be9785d8c639d355f32d34bef211e6ebb93d4bf7c508ee294f36f7b28ed3c8ed"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "245cf243eefe3de8c01d87638452190faad35fedb86524f688cbfcd8c34a4580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bbce9b6540b4d7397a5a70d2e0d98c03bd87e5b50d6e1c0dcb54f840ea04766"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aecfb1e231a1eab8d8e0f480d4caee017c8a19a5e62b0526e1eb72933f445b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a344033ac8d7e63ca32c0c445437f24ce568e8c129987770fe12acf855c23da"
    sha256 cellar: :any_skip_relocation, ventura:       "d432c358030be597fa5d3d59162ad049d83016cdf0c87a575fe6348fd2bb0b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc83094f05d97bfcb5780537bc89143aab3ba46c2dcb8e15e6b7f5cc3912ee2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9c01a42962930c999f67e188dfd76c1f0a390343551101066536a0eb19718a9"
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
