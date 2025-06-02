class Hellwal < Formula
  desc "Fast, extensible color palette generator"
  homepage "https://github.com/danihek/hellwal"
  url "https://github.com/danihek/hellwal/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a33d1c5257fe4b42e92cac7f055c6ed1a3e857fe52ab435924b316947d55e200"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b29e58646b2391aa7789e5a9f5f123ca3348881cf77685cd1e8167cdc0e0ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70ac6fbd2861baba5a96267ba402c2a824579d146c14c8a24febbac5adbcb5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "232ae8888f812cc13028e638d484ce639187362e35f257ca73b4907c8682a2cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad61a0ce7e32d075464eaeb3eaadd263eadc50c1d03b9df920da1e8cbf81a72a"
    sha256 cellar: :any_skip_relocation, ventura:       "419049de2bda47e54b8a8ab224c5ecdab29306522541e72e6cc43eb217bb8c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd029a9bca7810dfca9c45300f153a735d3ce5e7c93a2e532e2cbe4cd65a61f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b23953290d7eb3c7c73158227ef69b2517986868324ec96ac69c0e71c75e207"
  end

  def install
    system "make", "install", "DESTDIR=#{bin}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hellwal --version")

    (testpath/"hw.theme").write "%% color0  = #282828 %%"
    output = shell_output("#{bin}/hellwal --skip-term-colors -j -t hw.theme 2>&1", 1)
    assert_match "Not enough colors were specified in color palette", output
  end
end
