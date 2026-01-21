class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "d0201fb5fb6fbea95fc76318b343281ce9c622297b82133f53b2bfe2ddcf5a17"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7d57b9bdff9b9e8489767d08b8a7afe51a0903271f0c3d64b3975c7590e8d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05bba2b8f87114b01ccf7e4acfc18224af8d5a7996774b529461b43e4c184060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01d23a6db4d4a01a4f65f9c6ec4013f07476c93554a6b44f8c3fd1d9789e787"
    sha256 cellar: :any_skip_relocation, sonoma:        "a22c87d9960908afc5f86c5316a7ef3de460429bf2fd31a7a05524edb60b420c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa55d89227c4c3eccd74953f05a0f37d081fe2581c99ea7c5e6690a3a63e823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed36281b9081080b1fdb3209c55cd24ab140fd4c1ae782c92e4ba73a3271c70"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
