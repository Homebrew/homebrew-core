class Pdtm < Formula
  desc "ProjectDiscovery's Open Source Tool Manager"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/pdtm/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "13746a1da82961dcfc9d797206abd6ba75336879f2292228e92a2813000d1654"
  license "MIT"
  head "https://github.com/projectdiscovery/pdtm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2b9f3668495240e5a1b9e72e32372aec4b9b14ad6ca9400246bb1a7dffefecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17972afcb0cfb327b5992bdee4c21db685faceac1801d9a9e44f655105223792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce0d82087facc8a29e40df44f98b7fb24c6e5df5f4e91224e7ec559e9cbaf9f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "957cbbaa359f16f11d643bbe5b80cea868721da4d3308c431f1ac85e32a4eeb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b1038cf705b342650da77287d19b82681c25c6a99b194712abb24a6afd8e3a"
    sha256 cellar: :any,                 x86_64_linux:  "610dda1c5b04bf1d13fb6ce4a799663df5bc20e298f58e64f653f4cb0a5a6ec0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/pdtm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdtm -version 2>&1")
    assert_match "#{testpath}/.pdtm/go/bin", shell_output("#{bin}/pdtm -show-path")
  end
end
