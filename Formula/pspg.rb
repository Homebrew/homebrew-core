class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.1.tar.gz"
  sha256 "a4a4003982017261360bae24d5b38b3653d694d3d66140cf8fe7864d50958a8e"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a5340ff2fa5d02cfbaa18727952749af3a4f7946d60fd8e5eb888e2f60c499a"
    sha256 cellar: :any,                 arm64_big_sur:  "e02ac3ae1e2d31d0484d657d88a925a0f6cb1b06a7095cb22828f9ab4b873497"
    sha256 cellar: :any,                 monterey:       "3c8be4a6e02617d26bd6e06d614626f35d001c933bc4b2e82e778ffb170da97b"
    sha256 cellar: :any,                 big_sur:        "3703edc3a98f48bcfac8d95e69bc87f8930d7e0e839ff784d9877771d40d18f5"
    sha256 cellar: :any,                 catalina:       "27d9812a7df7a3940183f660f5861233fc846edc33d1de8707883a45a0a85aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9964dff52b1e160a001a7dc8e8d4005279fae7c68c367ac73d025176c48fb6c8"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
