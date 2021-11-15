class Envchain < Formula
  desc "Secure your credentials in environment variables"
  homepage "https://github.com/sorah/envchain"
  url "https://github.com/sorah/envchain/archive/v1.0.1.tar.gz"
  sha256 "09af1fe1cfba3719418f90d59c29c081e1f22b38249f0110305b657bd306e9ae"
  license "MIT"
  head "https://github.com/sorah/envchain.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b0a5fa3a01e3e241b4ae293e706dd4017dc6a11be8c0ca441858e8c97e94e50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a280127849e99bf3313f5d43b7bf1bf38cbffde964ca1c4e3968728b8a52cc8"
    sha256 cellar: :any_skip_relocation, monterey:       "6c39890c7202c7368102ba3eddcbdcf72c479b428d05e72777e9d839a9cb9983"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e3091b7e3202f68b9bca03aef6df8002048be8e7e6e77be736787e0c7393d7f"
    sha256 cellar: :any_skip_relocation, catalina:       "a8658954176e96b463565ea6b5c891b3635622c550ca32efb8ee2e3baec30062"
    sha256 cellar: :any_skip_relocation, mojave:         "3859bb68db413ee3f421351798082c456fbbb82896ef4ca2cdf439cc9d12fdbe"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0d615620e4b69e41aef92971fc1aa9a586be4f75be7813ef73ace103dd182684"
    sha256 cellar: :any_skip_relocation, sierra:         "42419c23d7dd363b9232918f69fa4ea01270b6eb4dc9c4b1c4d5170ff920fda3"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4e34971c35ec6a716995a5e8d491970809bb5ce6c5651676f70d757b4044c834"
    sha256 cellar: :any_skip_relocation, yosemite:       "1de7c8c17e489b1f832078d3e5c403133accd187f2e666b44bb4da5d1d74f9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819f762517ccd7edfac02c7fceef30a3554b12de32188219d0a7bb7b32fdb0f0"
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libsecret"
    depends_on "readline"
  end

  def install
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match "envchain version #{version}", shell_output("#{bin}/envchain 2>&1", 2)
  end
end
