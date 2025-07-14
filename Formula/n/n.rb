class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v10.2.0.tar.gz"
  sha256 "5914f0d5e89aadaaaeb803baa89a7582747b0c57ad30201b3522cd76f504c7d9"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "04a2dae2dd6d638355e8b7743f0fc82f1d665a92c907936e801c18e254038a31"
    sha256 cellar: :any_skip_relocation, ventura:       "04a2dae2dd6d638355e8b7743f0fc82f1d665a92c907936e801c18e254038a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
