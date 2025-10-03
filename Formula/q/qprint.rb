class Qprint < Formula
  desc "Encoder and decoder for quoted-printable encoding"
  homepage "https://www.fourmilab.ch/webtools/qprint/"
  url "https://www.fourmilab.ch/webtools/qprint/qprint-1.1.tar.gz"
  sha256 "ffa9ca1d51c871fb3b56a4bf0165418348cf080f01ff7e59cd04511b9665019c"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?qprint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a29390a05c5e5744170726101f054366cf8c2cf8d8112b861574a4f9327d9ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ac2245e4a3f2c14009c6e9c3418374623e94b32f7f265ffe6cd30f0693299a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f2189ee3bf4741aa2c3625d23cdd55109db17d854f0a6a01bc00bd944b28f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92e8b2bf88c82066a97efb04a8b65eab7f08a464d75bb9d4105e50a243f130cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f17bf6ccfb63afc8908771488d0b1ffbbbdad4a3575c0654fe11e031c89ef0a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05903a905caebf80944f4705898c5377849b7a411cf234614205b3136dba4a38"
    sha256 cellar: :any_skip_relocation, sonoma:         "1baf6813dacc645d4047a021f89ce5ea5e1c56b70c0e8cae12a694b41e8b5ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "3c1073fb345d02023615ffad4d949dd6fec097adf7f0947c58548061d42e5892"
    sha256 cellar: :any_skip_relocation, monterey:       "0cadd8be56fb57e11e69c2a144bfc204e36298458c71d327d5d76abfddee2e9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "500367c9c89f50739d2b09f37f72ba1e0ec5418398d4570bf51363a725f57189"
    sha256 cellar: :any_skip_relocation, catalina:       "081c0663cccb890326323fce7ac57b8bb020d3505eaf0d19f1824dd63c304de2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0e776f58e2f735c499f4fdb99568f2c0fd3854d5d86c482bb086cc674e43082d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adea30e44e1c128bf4f466fbca2a3eaad7f71bd90a9868492b8365611bb76489"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    msg = "test homebrew"
    encoded = pipe_output("#{bin}/qprint -e", msg)
    assert_equal msg, pipe_output("#{bin}/qprint -d", encoded)
  end
end
