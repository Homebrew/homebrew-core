class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "893f1979b453d655880c19552e1f894110a661a4057a58e95a4d7505bf6d7fa8"
  license "Apache-2.0"
  head "https://github.com/OJ/gobuster.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbbbd89652ba67e6a47ac28283e6d01323510fcf2f8961fd3a1652f7bff114a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbbbd89652ba67e6a47ac28283e6d01323510fcf2f8961fd3a1652f7bff114a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbbbd89652ba67e6a47ac28283e6d01323510fcf2f8961fd3a1652f7bff114a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de00cc18ba4a36cb4bba9c1bcda0c533cba5e38556db29b474d0b0467ab0bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "6de00cc18ba4a36cb4bba9c1bcda0c533cba5e38556db29b474d0b0467ab0bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ca402096692d79dc58ccb76395ce3c54cc211ad9e0b6ae5fe374e8eb7a4b70d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster --version")
  end
end
