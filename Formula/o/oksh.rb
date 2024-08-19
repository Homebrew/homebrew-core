class Oksh < Formula
  desc "Portable OpenBSD ksh, based on the public domain Korn shell (pdksh)"
  homepage "https://github.com/ibara/oksh"
  url "https://github.com/ibara/oksh/releases/download/oksh-7.5/oksh-7.5.tar.gz"
  sha256 "40b895c3f8e9311bfe2b230e9b3786712550ef488ced33bfd7cd3f89fceeed5d"
  license all_of: [:public_domain, "BSD-3-Clause", "ISC"]
  head "https://github.com/ibara/oksh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81c51efdca8f0ac4e0f9d69db474ff8c8a104f8eb231362f7a198065c5de9a8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24164bb9e10988f028f6356a699b5263dc8f63c47437c36b0f80a01a52f82bc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d25457b4ae0806aab2173d986bce4d0f8e27db1ebe6dd17b09034f4a03ab83e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "278fd1856493cce45ec88ce8e818e2e7f4052d6dff0cade53b096ab7f72edd53"
    sha256 cellar: :any_skip_relocation, ventura:        "b495c19fd1d9249bbb61688683a5371051e11b500e664eb117a59cd4e1bd7ade"
    sha256 cellar: :any_skip_relocation, monterey:       "f12671ac6ecf2363bcfcbc93e15eaa027fa55376d83622eefff287aab06aedb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8a32647584058e58db08b8cc476c04eace2fef232b78de2f845037a756a292f"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/oksh -c \"echo -n hello\"")
  end
end
