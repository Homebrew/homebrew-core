class Mongroup < Formula
  desc "Monitor a group of processes with mon"
  homepage "https://github.com/jgallen23/mongroup"
  url "https://github.com/jgallen23/mongroup/archive/0.4.1.tar.gz"
  sha256 "50c6fb0eb6880fa837238a2036f9bc77d2f6db8c66b8c9a041479e2771a925ae"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16deb20baa844034c6a1c8bfcb61971a71f576fbebd0dd6170321aeed2866ee7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16deb20baa844034c6a1c8bfcb61971a71f576fbebd0dd6170321aeed2866ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc40264f75aafc4f194f10d2b7472e152a4c9f58ec104db6ebeac3dc346c4370"
    sha256 cellar: :any_skip_relocation, ventura:        "16deb20baa844034c6a1c8bfcb61971a71f576fbebd0dd6170321aeed2866ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "16deb20baa844034c6a1c8bfcb61971a71f576fbebd0dd6170321aeed2866ee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2112e201508ee22715b2e318b2fd97ae0cf4044e1d74d0893abf12598fb72bc"
    sha256 cellar: :any_skip_relocation, catalina:       "57c107a2746fae7e9db832f54df3d5170449defc30334094939794288659f026"
    sha256 cellar: :any_skip_relocation, mojave:         "4c11751013bae001ff2dcf55c3566613e83fe0d9257e0691c9da7b2aec298918"
    sha256 cellar: :any_skip_relocation, high_sierra:    "230996b629ff1a72b405ba6c7fbb8cdd0fd06292b16bacf124bc2e30c5f9917e"
    sha256 cellar: :any_skip_relocation, sierra:         "d3065cb969df510f29b742e1d6606151328af2afe3542bb3ff3462e7551ade9b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8e801dac08ad7a776d698dc8bfc170f1df2fcb621561b86c789cc0e8098b1b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16deb20baa844034c6a1c8bfcb61971a71f576fbebd0dd6170321aeed2866ee7"
  end

  depends_on "mon"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mongroup", "-V"
  end
end
