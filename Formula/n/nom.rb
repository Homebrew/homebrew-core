class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://github.com/guyfedwards/nom/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "765b1a70790c7b2a2272adc9863b82b05db8a040ce5b35b5f25b0b816ed2f553"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1b81a28d305679df6b4c6f8f9b1f5b2e016d77c25136d7087b3ea0e536c589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5619529273fe8290353f9e2164058a7b30f2967467a2cda707306a5a963503bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "916db36547c31f1e10ae3795cac922483fbf6705fdc08f12fb8f08865c48304c"
    sha256 cellar: :any_skip_relocation, sonoma:        "701a66638ec7d58ab364b69835ddaf5f0efffb636da8e5bde1a1464b85ed35ab"
    sha256 cellar: :any_skip_relocation, ventura:       "def9204bc4135bf8b12774662a25e8366f9e098fe44a43db73c2b931082d8c3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a75418aff236e43fc9960322d4db8643ae886697929d40cda0e7798f2bedb73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f04d38b81d7db2d4ecc66aa6f347785246aa1ca103ebcc2c0c3191bf3decf3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
