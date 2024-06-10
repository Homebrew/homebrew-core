class Basex < Formula
  desc "Light-weight XML database and XPath/XQuery processor"
  homepage "https://basex.org"
  url "https://files.basex.org/releases/11.0/BaseX110.zip"
  version "11.0"
  sha256 "78f5e88a73a79bd06031e0864ed584dda843b04b7345e0220cb3309bd701ded1"
  license "BSD-3-Clause"

  livecheck do
    url "https://files.basex.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "986929b7e11b6a0560c4cfb7215efb2862f406c62feaa5662a6bbe40f2111ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "986929b7e11b6a0560c4cfb7215efb2862f406c62feaa5662a6bbe40f2111ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "986929b7e11b6a0560c4cfb7215efb2862f406c62feaa5662a6bbe40f2111ad4"
    sha256 cellar: :any_skip_relocation, sonoma:         "986929b7e11b6a0560c4cfb7215efb2862f406c62feaa5662a6bbe40f2111ad4"
    sha256 cellar: :any_skip_relocation, ventura:        "986929b7e11b6a0560c4cfb7215efb2862f406c62feaa5662a6bbe40f2111ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "986929b7e11b6a0560c4cfb7215efb2862f406c62feaa5662a6bbe40f2111ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621d1e759086815ed89685df9a95f8866bbc7ed0e043a537c35d3535f4d5066c"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    rm_rf "repo"
    rm_rf "data"
    rm_rf "etc"
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "1\n2\n3\n4\n5\n6\n7\n8\n9\n10", shell_output("#{bin}/basex '1 to 10'")
  end
end
