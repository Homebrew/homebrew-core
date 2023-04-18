class Flake < Formula
  desc "FLAC audio encoder"
  homepage "https://flake-enc.sourceforge.io"
  url "https://downloads.sourceforge.net/project/flake-enc/flake/0.11/flake-0.11.tar.bz2"
  sha256 "8dd249888005c2949cb4564f02b6badb34b2a0f408a7ec7ab01e11ceca1b7f19"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f0ff1a603cfd656ddb342b5295fcc85b7b1a83216911d0593a18c6bf6dbcfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2a1ccd83576e3e6d8f84d314be37100def324e53d31fab0de4446d53bbfc7e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a479261d3abb5f7cb8f4006cd025b7680d10148bdd66d817af0d040f4395de6"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9de6b4ef37f0237a1ee39ccda3e62ccd87d826d4fa27b347aa8ddc06d74f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "32cfb3d7b3ff5caddf8173824092d5dc0ca8e38953428b4c670e8d55145d9e9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "453cccc52dcc4b3028b2fad54706de68b8eac67b1dd8884265f883c7721f5ee0"
    sha256 cellar: :any_skip_relocation, catalina:       "2e330d1c60b4bac4b492eeac65b126c7af57c33ae5dcbf36c3fbb0dbba59a7a7"
    sha256 cellar: :any_skip_relocation, mojave:         "aa54eed5e2c9b94a6cba5cd2aa7491d7b8ca61d3b89b72f64c1b7343e973baf2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c5a8fe6d24125870a5d420ebf39ab2acf14d5646e86df61632dc8d2e77887114"
    sha256 cellar: :any_skip_relocation, sierra:         "b2eca0967c020b082f7d7f8c4d15765204ea63aa9332012074c852967a0fee07"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e521dae57260b2a71f161f16609530c854ff8ebee4252b0addf3c16b5abc982c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fab554771a1e61cc3b14670fd0394fef5b60c4e545558ef6eb75b33edf5b258"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"flake", test_fixtures("test.wav"), "-o", testpath/"test"
  end
end
