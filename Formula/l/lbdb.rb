class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.52.1.tar.gz"
  sha256 "186b263056bc979d399d1d7f29664e84dd7a4282ffbe4378cb567e55318d7929"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e10abfc3c9f3ed4a45edfe2caa265276eb0f0c788c5205d07565475baada9358"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26d0fcf12fc5b34e47e3db5a46f9831ced0fb27aca85ba5027569a400f420535"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c248dcc59fa3b06d9e06b99b28890b6cc0abb0befc3bbfffbcb37ab1adfe340f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "878500511fdf5242a88d2f5e5b93eb8a53e55af14563eef61aacf1cbf133e89a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b957b7363182461d81c65af5730b86c6aef5fe06bb1b80b42872900f73aaa47b"
    sha256 cellar: :any_skip_relocation, ventura:        "e9c3c09538c18af545e116b1669ca8d8bde510a5e8870a76731630b1cc67a7b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9330d60cc8d13e3cb3cbacf0be304fd72ee8a91ceaa85e05415be82882606fcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c658923b409f0398bde5d1cacdee3964f8620651f1d039788c782d5205e7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89941ede433bacad1a798d2d5e16962df39cb8ce184485c19e755b56feb4e6a4"
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
