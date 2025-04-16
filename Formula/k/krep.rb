class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "964e9ea29a1f1a809ce2a4aadb1ea3273b45b8187304b01c9aaec57a8a510ab7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff59368a8e74a2bd22ab6897bfc7b02ac05194a233445d5c706d3ecc1009f293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62e88ca0e5679f7ab949cca68cc7a5c1aa8284ebb39517e4b66212b26b1949f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f5e9b5511e7213671ca4a7704a44f4c7bfc661fc743c7ca5fcd1c10248c6b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab99bb25bd6d413d591953be092923d2bf6a1ce208ed86be0cf0d02064b2a1f8"
    sha256 cellar: :any_skip_relocation, ventura:       "5c446bc481a88c4fea5bd9f8915c7bf6f01bd119531019be03c6af62c888a3a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d83cf38c0f354c6e3471a2903b6e6b46183e90e2df49f2c3170b9d7701e17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee84fd21ebc2647c525d5c437e5abbbaf0a3022f42d3785f0b1bf6c628bcef0"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
